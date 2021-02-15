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

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  auto sortedDigits = new Generator!(uint[])(sortedDigitsInit!uint(1, maxDigits));

  writeln("digit fifth powers");
  timer.start();

  auto sums = sortedDigits
    .dropOne
    .map!(a => a, a => a.map!(a => a ^^ 5).sum())
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
    sum = digits.map!(a => a ^^ 5).sum();
  } while (digits.length <= sum.toDigits().length);

  return digits.length - 1;
}
