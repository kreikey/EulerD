#!/usr/bin/env rdmd -i -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong sum;

  timer.start();

  sum = iota(1, 28124).filter!(isNonAbundantSum).sum();

  timer.stop();
  writefln("The sum of all the positive integers which cannot be written as the sum of two abundant numbers is: %s", sum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

bool isAbundant(long num) {
  if (reduce!((a, b) => a + b)(0L, num.getProperDivisors()) > num)
    return true;
  else
    return false;
}

bool isAbundantSum(long num) {
  foreach (i; 1..num) {
    if (i.isAbundant() && (num - i).isAbundant())
      return true;
  }
  return false;
}

bool isNonAbundantSum(long num) {
  writeln(num);
  return !isAbundantSum(num);
}
