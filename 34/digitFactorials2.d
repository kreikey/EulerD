#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.traits;
import std.range;
import std.algorithm;
import std.concurrency;
import kreikey.bigint;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  auto sortedDigits = new Generator!(uint[])(sortedDigitsInit!uint(1, maxDigits));

  writeln("digit factorials");
  timer.start();

  auto sums = sortedDigits
    .drop(2)
    .map!(a => a, a => a.map!factorial.sum())
    .map!(a => a[0], a => a[1], a => a[1].toDigits.asort())
    .filter!(a => a[0] == a[2])
    .map!(a => a[1])
    .array();

  writefln("The numbers that are equal to the sum of factorials of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
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
