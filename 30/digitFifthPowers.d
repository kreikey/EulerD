#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;

void main() {
  StopWatch timer;
  uint[] digits;
  uint[] sumDigs;
  ulong sum;
  ulong[] sums;
  enum maxDigits = getMaxDigits();

  writeln("digit fifth powers");
  timer.start();

  digits ~= 1;

  do {
    sum = digits.map!(a => a ^^ 5).sum();
    sumDigs = sum.toDigits.asort!((a, b) => a > b)();

    if (sum != 1 && digits == sumDigs)
      sums ~= sum;

    if (sumDigs.length != digits.length)
      digits.length = sumDigs.length;
    else
      digits.incrementDigitsCombo();

  } while (digits.length <= maxDigits);

  writefln("The numbers that can be written as the sum of fifth powers of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

ulong getMaxDigits() {
  ulong sum = 0;
  uint[] digits;

  do {
    sum = 0;
    digits ~= 9;
    sum = digits.map!(a => a ^^ 5).sum();
  } while (digits.length <= sum.toDigits().length);

  return digits.length - 1;
}

void incrementDigitsCombo(ref uint[] digits) {
  for (ulong i = digits.length - 1; i > 0; i--)
    if (digits[i] < digits[i - 1]) {
      digits[i]++;
      if (i < digits.length - 1)
        digits[i + 1 .. $] = 0;
      return;
    }

  if (digits[0] < 9) {
    digits[0]++;
    if (digits.length > 1)
      digits[1 .. $] = 0;
  } else
    digits.length++;
}
