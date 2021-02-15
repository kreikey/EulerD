#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.concurrency;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;

enum exponent = 5;

void main() {
  StopWatch timer;
  uint[] digits;
  uint[] sumDigs;
  ulong sum;
  uint[] sums;
  enum maxDigits = getMaxDigits();

  writeln("digit fifth powers");
  timer.start();

  auto sortedDigits = new Generator!(uint[])(sortedDigitsInit!uint(1, maxDigits));

  sums = sortedDigits
    .dropOne
    .map!(a => a, a => a
        .map!(b => b ^^ exponent)
        .sum())
    .map!(a => a[0], a => a[1], a => a[1].toDigits.asort())
    .filter!(a => a[0] == a[2])
    .map!(a => a[1])
    .array();

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
    sum = digits.map!(a => a ^^ exponent).sum();
  } while (digits.length <= sum.toDigits().length);

  return digits.length - 1;
}
