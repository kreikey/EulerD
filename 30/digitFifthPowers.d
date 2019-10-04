#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

alias asortDescending = (ubyte[] a) => sort!((b, c) => c < b)(a).array();
enum exponent = 5;

void main() {
  StopWatch timer;
  ubyte[] digits;
  ubyte[] sumDigs;
  ulong sum;
  ulong[] sums;
  enum maxDigits = getMaxDigits();

  timer.start();

  digits ~= 1;

  do {
    sum = digits.map!(a => a ^^ exponent).sum();
    sumDigs = sum.toUbytes.asortDescending();

    if (sum != 1 && digits == sumDigs) {
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

  writefln("The numbers that can be written as the sum of fifth powers of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

ulong getMaxDigits() {
  ulong sum = 0;
  ubyte[] digits;

  do {
    sum = 0;
    digits ~= 9;
    sum = digits.map!(a => a ^^ exponent).sum();
  } while (digits.length <= sum.toUbytes().length);

  return digits.length - 1;
}

ubyte[] toUbytes(ulong source) {
  ulong maxPowTen = 1;
  ubyte[] result;

  while (maxPowTen <= source) {
    maxPowTen *= 10;
  } 

  maxPowTen /= 10;

  if (maxPowTen == 0) {
    result ~= 0;
    return result;
  }
  
  while (maxPowTen > 0) {
    result ~= cast(ubyte)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
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
