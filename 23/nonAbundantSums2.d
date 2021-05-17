#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.functional;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong sum;

  timer.start();

  sum = iota(1, 28124).filter!(isNonAbundantSum).sum();

  timer.stop();
  writefln("The sum of non-abundant numbers below 28124 is: %s", sum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

bool isAbundant(long num) {
  return (memoize!(getProperDivisors!long)(num).sum() > num);
}

bool isAbundantSum(long num) {
  foreach (n; 1..num) {
    if (memoize!isAbundant(n) && memoize!isAbundant(num - n))
      return true;
  }
  return false;
}

bool isNonAbundantSum(long num) {
  return !isAbundantSum(num);
}
