#!/usr/bin/env rdmd -i -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.functional;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong sum;

  writeln("Non-abundant sums");

  timer.start();

  sum = iota(1, 28124).filter!(not!isAbundantSum).sum();

  timer.stop();
  writefln("The sum of all the positive integers which cannot be written as the sum of two abundant numbers is: %s", sum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

bool isAbundant(uint num) {
  return memoize!(getProperDivisors!uint)(num).sum() > num;
}

bool isAbundantSum(uint num) {
  foreach (n; 1 .. num) {
    if (memoize!isAbundant(n) && memoize!isAbundant(num - n))
      return true;
  }
  return false;
}
