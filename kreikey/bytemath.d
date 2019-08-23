module kreikey.bytemath;

import std.range;
import std.algorithm;
import std.stdio;
import std.range;
import std.array;

alias rstr = (const byte[] value) => value.retro.map!(a => cast(immutable(char))(a + '0')).array();
alias rbytes = (const char[] value) => value.retro.map!(a => cast(byte)(a - '0')).array();
alias isNotEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) != 0;
alias isEqualTo = (const(byte)[] left, const(byte)[] right) => left.compare(right) == 0;
alias isGreaterThan = (const(byte)[] left, const(byte)[] right) => left.compare(right) > 0;
alias isLessThan = (const(byte)[] left, const(byte)[] right) => left.compare(right) < 0;

byte[] add(const(byte)[] left, const(byte)[] right) {
  byte[] result;
  result.reserve(left.length + right.length + 1);

  if (left.length < right.length) {
    swap(left, right);
  }

  result ~= left;
  result.accumulate(right);

  return result;
}

byte[] accumulate(ref byte[] left, const(byte)[] right) {
  byte carry = 0;

  if (left.length < right.length)
    throw new Exception("left is shorter than right");

  for (int i = 0; i < left.length; i++) {
    left[i] += (right.length > i ? right[i] : 0) + carry;
    carry = left[i] / 10;
    left[i] %= 10;
  }

  if (carry)
    left ~= carry;

  return left;
}

byte[] sub(const(byte)[] left, const(byte)[] right) {
  if (left.isLessThan(right))
    throw new Exception("left is less than right");

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
    writeln(e.msg);
  }
}

byte[] decumulate(ref byte[] left, const(byte)[] right) {
  if (left.isLessThan(right))
    throw new Exception("left is less than right");

  byte[] toAdd = new byte[right.length];
  toAdd.fill(cast(byte)9);
  toAdd[] -= right[];
  left.accumulate(toAdd);
  left.accumulate([1]);
  left.length--;
  
  while(left[$-1] == 0 && left.length > 1)
    left.length--;

  return left;
}

int compare(const(byte)[] left, const(byte)[] right) {
  if (left.length < right.length)
    return -1;
  else if (left.length > right.length)
    return 1;

  for (long i = cast(long)left.length - 1; i >= 0; i--)
    if (left[i] < right[i])
      return -1;
    else if (left[i] > right[i])
      return 1;

  return 0;
}

