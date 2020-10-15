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
  alias Coprimes = Generator!ulong;

  timer.start();

  auto denominators = iota(2, 12001)
    .map!getCoprimes
    .join();
  writeln(denominators.length);

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
/*
