#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.datetime.stopwatch;
import std.range;
import std.math;
import std.typecons;
import std.concurrency;
import std.conv;
import std.functional;
import kreikey.intmath;
import kreikey.primes;

void main() {
  StopWatch timer;
  alias Coprimes = Generator!ulong;

  timer.start();

  writeln("Counting fractions");

  auto fractionCount = getTotientsSum(1000000) - 1;
  writeln("The number of reduced proper fractions with denominators from 2 through 1,000,000 is:");
  writeln("The sum of the totients of 2 through 1,000,000, which is:");
  writeln(fractionCount);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong getTotientsSum(ulong topNumber) {
  ulong sum = 0;
  ulong[] factors = makePrimes
    .until!((a, b) => a >= b)(topNumber)
    .array();

  void inner(ulong baseNumber, ulong multiplier, ulong[] someFactors, ulong[] distinctFactors) {
    ulong totient = baseNumber == 1 ? 1 : multiplier * (baseNumber - memoize!(getNonCoprimeCount!ulong)(distinctFactors[1..$]));
    sum += totient;

    foreach (i, f; someFactors) {
      if (baseNumber * multiplier * f > topNumber)
        break;

      if (f == distinctFactors[$-1])
        inner(baseNumber, multiplier * f, someFactors[i .. $], distinctFactors);
      else
        inner(baseNumber * f, multiplier, someFactors[i .. $], distinctFactors ~ f);
    }
  }

  inner(1, 1, factors, [1]);

  return sum;
}

/*
T getNonCoprimeCount(T)(T[] factors) if (isIntegral!T) {
  bool[] mask = new bool[factors.length];
  T product = 0;
  T nonCoprimes = 0;
  T innerSum = 0;
  bool subtract = false;

  for (T k = 1; k <= mask.length; k++) {
    mask[] = false;
    mask[k .. $] = true;
    innerSum = 0;

    do {
      product = zip(factors, mask).filter!(a => a[1]).map!(a => a[0]).fold!((a, b) => a * b)(T(1));
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
