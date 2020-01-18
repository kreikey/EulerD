#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.traits;
import std.range;
import std.algorithm;
import kreikey.bigint;
import kreikey.intmath;
import kreikey.bytemath;

alias asortDescending = (a) {a.sort!((b, c) => c < b)(); return a;};

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  uint[] digits;
  uint[] sumDigs;
  ulong sum;
  ulong[] sums;

  writeln("digit factorials");
  timer.start();

  digits ~= 1;

  do {
    sum = digits.map!(factorial).sum();
    sumDigs = sum.toDigits.asortDescending();

    if (sum > 2 && digits == sumDigs)
      sums ~= sum;

    if (sumDigs.length != digits.length)
      digits.length = sumDigs.length;
    else
      digits.incrementDigitsCombo();

  } while (digits.length <= maxDigits);

  writefln("The numbers that are equal to the sum of factorials of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
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

ulong getMaxDigits() {
  ulong result = 0;
  ulong digitCount = 0;

  do {
    digitCount++;
    result += factorial(9);
  } while (digitCount <= result.toDigits.length);

  digitCount--;

  return digitCount;
}

