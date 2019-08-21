module kreikey.bytemath;

import std.range;
import std.algorithm;
import std.stdio;

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

byte[] rbytes(const char[] value) {
  return value.retro.map!(a => cast(byte)(a - '0')).array();
}

string rstr(const byte[] value) {
  return value.retro.map!(a => cast(immutable(char))(a + '0')).array();
}

