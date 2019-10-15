#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.traits;
import std.range;
import std.algorithm;

alias asortDescending = (ubyte[] a) => sort!((b, c) => c < b)(a).array();

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  ubyte[] digits;
  ubyte[] sumDigs;
  ulong sum;
  ulong[] sums;

  timer.start();

  digits ~= 1;

  do {
    sum = digits.map!(factorial).sum();
    sumDigs = sum.toDigits.asortDescending();

    if (sum > 2 && digits == sumDigs) {
      sums ~= sum;
    }

    if (sumDigs.length > digits.length) {
      digits.length++;
    } else if (sumDigs.length < digits.length) {
      digits.length--;
    } else {
      digits.incrementDigitsCombo();
    }

  } while (digits.length <= maxDigits);

  writefln("The numbers that are equal to the sum of factorials of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

void incrementDigitsCombo(ref ubyte[] digits) {
  for (ulong i = digits.length - 1; i > 0; i--) {
    if (digits[i] < digits[i - 1]) {
      digits[i]++;
      if (i < digits.length - 1)
        digits[i + 1 .. $] = 0;
      return;
    }
  }

  if (digits[0] < 9) {
    digits[0]++;
    if (digits.length > 1)
      digits[1 .. $] = 0;
  } else
    digits.length++;
}

ulong factorial(ulong number) {
  ulong result = 1;

  foreach (n; 1..number+1)
    result *= n;

  return result;
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

ubyte[] toDigits(ulong source) {
  ulong maxPowTen = 1;
  ubyte[] result;

  if (source == 0) {
    return [0];
  }

  while (maxPowTen <= source) {
    maxPowTen *= 10;
  } 

  maxPowTen /= 10;

  while (maxPowTen > 0) {
    result ~= cast(ubyte)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
}

