#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.datetime.stopwatch;
import std.range;
import std.math;
import std.typecons;
import std.concurrency;
import std.conv;
import kreikey.intmath;
import kreikey.primes;

void main() {
  StopWatch timer;
  ulong top = 12000;

  timer.start();

  writeln("Counting fractions");

  auto number = iota(2, top + 1)
    .map!(a => zip(getCoprimes(a), repeat(a)))
    .join
    .filter!(a => double(a[0])/a[1] > 1.0/3 && double(a[0])/a[1]< 1.0/2)
    .count();
  
  writefln("The number of fractions with denominators from 2 through %s", top);
  writeln("between 1/3 and 1/2 is:");
  writeln(number);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
ulong[] getCoprimes(ulong number) {
  ulong[] result;
  ulong[] factors = makePrimes
    .until!((a, b) => a >= b)(number)
    .setDifference(distinctPrimeFactors(number))
    .array();

  void inner(ulong product, ulong[] someFactors) {
    ulong nextProduct;

    result ~= product;

    foreach (i, f; someFactors) {
      nextProduct = product * f;

      if (nextProduct > number)
        break;

      inner(nextProduct, someFactors[i .. $]);
    }
  }

  inner(1, factors);

  return result;
}
*/
