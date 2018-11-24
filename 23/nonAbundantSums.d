#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string args[]) {
  StopWatch sw;
  ulong sum;

  sw.start();

  sum = iota(1, 28124).filter!(isNonAbundantSum).sum();

  sw.stop();
  writefln("The sum of non-abundant numbers below 28124 is: %s", sum);
  writefln("finished in %s milliseconds", sw.peek.msecs());
}

bool isAbundant(long num) {
  if (reduce!((a, b) => a + b)(num.getFactors()) > num)
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
  return !isAbundantSum(num);
}
