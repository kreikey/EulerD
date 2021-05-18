#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import kreikey.intmath;
import std.functional;

alias distinctPrimeFactors = memoize!(getDistinctPrimeFactors2!ulong);
//alias distinctPrimeFactors = distinctPrimeFactors2;

void main() {
  StopWatch timer;
  alias InfIota = recurrence!((a, n) => a[n-1]+1, ulong);

  timer.start();
  writeln("Distinct prime factors");

  auto fourDistinctPrimeFactors = InfIota(1uL)
    .map!(a => a, a => distinctPrimeFactors(a).length)
    .group!((a, b) => a[1] == b[1])
    .find!(a => a[0][1] == 4 && a[1] == 4)
    .front[0][0];

  auto fourDistinctPrimeFactorsCopy = fourDistinctPrimeFactors;

  foreach (i; 0..4) {
    writefln("%s: %(%s, %)", fourDistinctPrimeFactorsCopy, fourDistinctPrimeFactorsCopy.distinctPrimeFactors());
    fourDistinctPrimeFactorsCopy++;
  }

  timer.stop();

  writefln("The first four consequtive numbers with four distinct prime factors starts with: %s", 
          fourDistinctPrimeFactors);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
