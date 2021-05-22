module kreikey.digits;

import std.range;
import std.algorithm;
import std.stdio;
import std.traits;

ulong countDigits(uint base = 10)(ulong source) {
  ulong count = 0;

  while (source != 0) {
    source /= base;
    count++;
  }

  return count;
}

uint[] toDigits(uint base = 10)(ulong source) {
  uint[] result;

  while (source != 0) {
    result ~= cast(uint)(source % base);
    source /= base;
  }

  std.algorithm.reverse(result);

  return result;
}


uint[] toDigits(const char[] source) {
  return source.map!(a => a - '0').array();
}


ulong toNumber(ulong base = 10)(uint[] digits) 
if (isIntegral!(typeof(base))) {
  ulong result;

  for (size_t i = 0; i < digits.length; i++) {
    result += ulong(digits[i]) * ulong(base) ^^ ulong(digits.length - i - 1);
  }

  return result;
}

uint[] toString(uint base = 10)(ulong source) {
  return source.toDigits!base(source).toString();
}

string toString(uint[] digits) {
  return digits.map!(a => cast(immutable(char))(a + '0')).array();
}

T[] dror(T)(T[] digits) {
  T temp = digits[$-1];

  for (size_t i = digits.length-1; i > 0; i--)
    digits[i] = digits[i-1];

  digits[0] = temp;

  return digits;
}

ulong dror(T)(T source)
if(isIntegral!T) {
  return source.toDigits.dror.toNumber();
}

T[] drol(T)(T[] digits) {
  T temp = digits[0];

  for (size_t i = 0; i < digits.length-1; i++)
    digits[i] = digits[i+1];

  digits[$-1] = temp;

  return digits;
}

ulong drol(T)(T source)
if(isIntegral!T) {
  return source.toDigits.drol.toNumber();
}

ulong reverse(ulong source) {
  auto temp = source.toDigits();
  std.algorithm.reverse(temp);
  return temp.toNumber();
}

bool isPalindrome(T)(T num) 
if (isIntegral!T || is(T == BigInt)) {
  if (num == num.reverse())
    return true;
  else
    return false;
}
