module kreikey.bytemath;

import std.range;
import std.algorithm;
import std.stdio;
import std.array;

alias rstr = (const byte[] value) => value.retro.map!(a => cast(immutable(char))(a + '0')).array();
alias rbytes = (const char[] value) => value.retro.map!(a => cast(byte)(a - '0')).array();
alias isNotEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) != 0;
alias isEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) == 0;
alias isGreaterThan = (const(byte)[] left, const(byte)[] right) => left.compare(right) > 0;
alias isLessThan = (const(byte)[] left, const(byte)[] right) => left.compare(right) < 0;
alias isGreaterThanOrEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) >= 0;
alias isLessThanOrEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) <= 0;

byte[] add(const(byte)[] left, const(byte)[] right) {

  if (left.length < right.length) {
    swap(left, right);
  }

  byte[] result = left.dup;
  result.accumulate(right);

  return result;
}

byte[] accumulate(ref byte[] left, const(byte)[] right) {
  byte carry = 0;

  if (left.length < right.length)
    throw new Exception("left is shorter than right");

  for (ulong i = 0; i < left.length; i++) {
    left[i] += (right.length > i ? right[i] : 0) + carry;
    carry = left[i] / 10;
    left[i] %= 10;
  }

  if (carry)
    left ~= carry;

  return left;
}

byte[] sub(const(byte)[] left, const(byte)[] right) {
  if (left.isLessThan(right)) {
    writefln("sub left: %s\tright: %s", left.rstr(), right.rstr());
    throw new Exception("left is less than right");
  }

  byte[] result = left.dup;
  result.decumulate(right);

  return result;
}
unittest {
  byte[] left = "456".rbytes();
  byte[] right = "123".rbytes();
  string result;

  result = left.sub(right).rstr();
  assert(result == "333");
  right = "456".rbytes();
  result = left.sub(right).rstr();
  assert(result == "0");
  right = "457".rbytes();
  try {
    left.sub(right);
  } catch (Exception e) {
    writeln("exception caught: ", e.msg);
  }
}

byte[] decumulate(ref byte[] left, const(byte)[] right) {
  if (left.isLessThan(right))
    throw new Exception("left is less than right");

  byte[] toAdd = new byte[left.length];
  toAdd[] = 9;
  toAdd[0 .. right.length] -= right[];
  left.accumulate(toAdd);
  left.accumulate([1]);
  
  do
    left.length--;
  while(left[$-1] == 0 && left.length > 1);

  return left;
}

int compare(const(byte)[] left, const(byte)[] right) {
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

byte[] mul(const(byte)[] left, const(byte)[] right) {
  byte[] z0;
  byte[] z1;
  byte[] z2;
  ulong m;

  // Take care of base case where one or both operands are of length 1
  if (left.length == 1)
    return mulSingleDigit(right, left[0]);
  else if (right.length == 1)
    return mulSingleDigit(left, right[0]);

  m = left.length > right.length ? left.length / 2 : right.length / 2;

  // Split and handle out-of-bounds indices
  auto highLeft = m >= left.length ? cast(byte[])[0] : left[m .. $];
  auto lowLeft = m >= left.length ? left : left[0 .. m];
  auto highRight = m >= right.length ? cast(byte[])[0] : right[m .. $];
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

byte[] mulSingleDigit(const(byte)[] left, byte digit) {
  byte[] result = left.dup;
  byte carry = 0;

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

byte[] shiftBig(const(byte)[] digits, ulong amount) {
  byte[] result = new byte[digits.length + amount];

  result[0 .. amount] = 0;
  result[amount .. $] = digits[];

  while (result.length > 1 && result[$-1] == 0)
    result.length--;

  return result;
}

