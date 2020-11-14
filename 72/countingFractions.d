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

  auto fractionCount = iota(2, 1000001)
    .map!getTotient
    .sum();

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


ulong getTotient2(ulong number) {
  auto factorGroups = getPrimeFactorGroups(number);
  auto duplicateFactorProduct = factorGroups.fold!((a, b) => tuple(a[0] * b[0] ^^ (b[1] - 1), 1))(tuple(1uL, 1u))[0];
  auto factors = factorGroups.map!(a => a[0]).array();
  ulong nonCoprimes = memoize!getNonCoprimeCount(factors);
  nonCoprimes *= duplicateFactorProduct;

  return number == 1 ? 1 : number - nonCoprimes;
}
*/
