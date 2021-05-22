module kreikey.bytemath;

import std.range;
import std.algorithm;
import std.stdio;
import std.traits;

alias isNotEqualTo = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) != 0;
alias isEqualTo = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) == 0;
alias isGreaterThan = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) > 0;
alias isLessThan = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) < 0;
alias isGreaterThanOrEqualTo = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) >= 0;
alias isLessThanOrEqualTo = (const(ubyte)[] left, const(ubyte)[] right) => left.compare(right) <= 0;

enum MulThreshold = 70;

ubyte[] add(const(ubyte)[] left, const(ubyte)[] right) {

  if (left.length < right.length)
    swap(left, right);

  ubyte[] result = left.dup;
  result.accumulate(right);

  return result;
}

ubyte[] accumulate(ref ubyte[] left, const(ubyte)[] right) {
  ubyte carry = 0;

  if (left.length < right.length) {
    left.length = right.length;
  }

  for (ulong i = 0; i < left.length; i++) {
    left[i] += (right.length > i ? right[i] : 0) + carry;
    carry = left[i] / 10;
    left[i] %= 10;
  }

  if (carry)
    left ~= carry;

  return left;
}

ubyte[] sub(const(ubyte)[] left, const(ubyte)[] right) {
  if (left.isLessThan(right)) {
    writefln("sub left: %s\tright: %s", left.rstr(), right.rstr());
    throw new Exception("left is less than right");
  }

  ubyte[] result = left.dup;
  result.decumulate(right);

  return result;
}
unittest {
  ubyte[] left = "456".rbytes();
  ubyte[] right = "123".rbytes();
  string result;

  result = left.sub(right).rstr();
  assert(result == "333");
  right = "456".rbytes();
  result = left.sub(right).rstr();
  assert(result == "0");
  right = "457".rbytes();

  try
    left.sub(right);
  catch (Exception e)
    writeln("exception caught: ", e.msg);
}

ubyte[] decumulate(ref ubyte[] left, const(ubyte)[] right) {
  if (left.isLessThan(right))
    throw new Exception("left is less than right");

  ubyte[] toAdd = new ubyte[left.length];
  toAdd[] = 9;
  toAdd[0 .. right.length] -= right[];
  left.accumulate(toAdd);
  left.accumulate([1]);
  
  do
    left.length--;
  while(left[$-1] == 0 && left.length > 1);

  return left;
}

int compare(const(ubyte)[] left, const(ubyte)[] right) {
  if (left.length < right.length)
    return -1;
  else if (left.length > right.length)
    return 1;

  for (ulong i = left.length - 1; i < ulong.max; i--)
    if (left[i] < right[i])
      return -1;
    else if (left[i] > right[i])
      return 1;

  return 0;
}

ubyte[] mulSmall(const(ubyte)[] left, const(ubyte)[] right) {
  ubyte carry;
  ubyte d;
  ubyte[] result;
  ubyte[] part;

  result.reserve(left.length + right.length + 1);

  if (left.length < right.length)
    swap(left, right);

  for (size_t i = 0; i < right.length; i++) {
    part = mulSingleDigit(left, right[i]);
    part.shiftBigInPlace(i);
    result.accumulate(part);
    carry = 0;
    part = [];
  }

  while (result[$-1] == 0 && result.length > 1)
    result.length--;

  return result;
}

ubyte[] mul(const(ubyte)[] left, const(ubyte)[] right) {
  ubyte[] z0;
  ubyte[] z1;
  ubyte[] z2;
  ulong m;

  // Take care of base case where one or both operands are of length 1
  if (left.length < MulThreshold && right.length < MulThreshold)
    return mulSmall(left, right);

  m = left.length > right.length ? left.length / 2 : right.length / 2;

  // Split and handle out-of-bounds indices
  auto highLeft = m >= left.length ? cast(ubyte[])[0] : left[m .. $];
  auto lowLeft = m >= left.length ? left : left[0 .. m];
  auto highRight = m >= right.length ? cast(ubyte[])[0] : right[m .. $];
  auto lowRight = m >= right.length ? right : right[0 .. m];

  // Handle leading zeros
  while (lowLeft[$ - 1] == 0 && lowLeft.length > 1)
    lowLeft.length--;
  while(lowRight[$ - 1] == 0 && lowRight.length > 1)
    lowRight.length--;

  z2 = mul(highLeft, highRight);
  z0 = mul(lowLeft, lowRight);
  z1 = mul(add(lowLeft, highLeft), add(lowRight, highRight));

  return z2
    .shiftBig(2 * m)
    .add(z1
        .sub(z2)
        .sub(z0)
        .shiftBig(m))
    .add(z0);
}

ubyte[] mulSingleDigit(const(ubyte)[] left, ubyte digit) {
  auto result = left.dup;
  ubyte carry = 0;

  for (ulong i = 0; i < result.length; i++) {
    result[i] *= digit;
    result[i] += carry;
    carry = result[i] / 10;
    result[i] %= 10;
  }

  if (carry)
    result ~= carry;

  while (result.length > 1 && result[$-1] == 0)
    result.length--;

  return result;
}

ubyte[] shiftBig(const(ubyte)[] digits, ulong amount) {
  auto temp = digits.dup;
  return shiftBigInPlace(temp, amount);
}

ref ubyte[] shiftBigInPlace(ref ubyte[] digits, ulong amount) {
  if (amount == 0)
    return digits;
  if (digits.length == 1 && digits[$-1] == 0)
    return digits;

  digits.length = digits.length + amount;

  for (size_t i = digits.length - 1; i >= amount; i--) {
    digits[i] = digits[i - amount];
    digits[i - amount] = 0;
  }

  return digits;
}

ubyte[] rbytes(const char[] value) {
  return value.retro.map!(a => cast(ubyte)(a - '0')).array();
}

ubyte[] rbytes(ulong value) {
  ubyte[] result;

  while (value != 0) {
    result ~= cast(ubyte)(value % 10);
    value /= 10;
  }

  return result;
}

string rstr(const ubyte[] value) {
  return value.retro.map!(a => cast(immutable(char))(a + '0')).array();
}
