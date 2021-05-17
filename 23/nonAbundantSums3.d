#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;
import kreikey.intmath;

void main() {
  StopWatch timer;
  uint sum = 0;
  bool[uint] abundantSums = null;

  writeln("Non-abundant sums");

  timer.start();

  auto abundantNumbers = iota(1, 28124)
    .filter!isAbundant
    .array();

  foreach (i, n; abundantNumbers[0 .. $]) {
    foreach (m; abundantNumbers[i .. $]) {
      sum = n + m;
      if (sum > 28123)
        break;
      abundantSums[sum] = true;
    }
  }

  auto nonAbundantSumSum = iota(1, 28124)
    .filter!(a => a !in abundantSums)
    .sum();

  timer.stop();

  writefln("The sum of all the positive integers which cannot be written as the sum of two abundant numbers is: %s", nonAbundantSumSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isAbundant(uint num) {
  return (memoize!(getProperDivisors!uint)(num).sum() > num);
}
