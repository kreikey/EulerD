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
  auto multiTotients = getMultiTotientsInit(1000000);
  auto totientPairs = new Generator!(Tuple!(ulong, ulong))(multiTotients);

  timer.start();

  writeln("Counting fractions");
  writeln("The number of reduced proper fractions with denominators from 2 through 1,000,000 is:");
  writeln("The sum of the totients of 2 through 1,000,000, which is:");

  totientPairs
    .dropOne
    .map!(a => a[1])
    .sum
    .writeln();

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
long getNonCoprimeCount(ulong[] factors) {
  bool[] mask = new bool[factors.length];
  ulong product = 0;
  ulong nonCoprimes = 0;
  ulong innerSum = 0;
  bool subtract = false;

  for (ulong k = 1; k <= factors.length; k++) {
    mask[] = false;
    mask[k .. $] = true;
    innerSum = 0;

    do {
      product = zip(factors, mask).fold!((a, b) => tuple(b[1] ? a[0] * b[0] : a[0], true))(tuple(1uL, true))[0];
      innerSum += product;
    } while (nextPermutation(mask));

    if (subtract)
      nonCoprimes -= innerSum;
    else
      nonCoprimes += innerSum;

    subtract = !subtract;
  }

  return nonCoprimes;
}
*/
