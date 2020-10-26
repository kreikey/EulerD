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

  writeln("Counting fractions");

  auto fractionCount = getTotientsSum(1000000) - 1;
  writeln("The number of reduced proper fractions from 1/1000000 through 999999/1000000 is:");
  writeln("The sum of the totients of 2 through 1,000,000, which is:");
  writeln(fractionCount);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
ulong getNonCoprimeCount(ulong[] factors) {
  bool[] mask = new bool[factors.length];
  ulong product = 0;
  ulong nonCoprimes = 0;
  ulong innerSum = 0;
  bool subtract = false;

  for (ulong k = 1; k < factors.length; k++) {
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

  if (subtract)
    nonCoprimes -= 1;
  else
    nonCoprimes += 1;

  return nonCoprimes;
}

ulong getTotientsSum(ulong topNumber) {
  ulong sum = 0;
  ulong[] factors = makePrimes
    .until!((a, b) => a >= b)(topNumber)
    .array();
  Tuple!(ulong, ulong)[] numbersTotients;

  void inner(ulong baseNumber, ulong multiplier, ulong[] someFactors, ulong[] distinctFactors) {
    ulong totient = baseNumber == 1 ? 1 : multiplier * (baseNumber - memoize!getNonCoprimeCount(distinctFactors[1..$]));
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
*/
