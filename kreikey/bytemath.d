module kreikey.bytemath;

import std.range;

byte[] add(const(byte)[] left, const(byte)[] right) {
  byte[] result = left.dup;

  result.accumulate(right);
  return result;
}

byte[] accumulate(ref byte[] left, const(byte)[] right) {
  byte carry = 0;

  if (left.length < right.length)
    left.length = right.length;

  foreach (ref a, b; lockstep(left, right)) {
    a += b + carry;
    carry = a / 10;
    a %= 10;
  }
  if (carry)
    left ~= carry;

  return left;
}
