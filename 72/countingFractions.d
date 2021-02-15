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

  auto fractionCount = iota(2uL, 1000001)
    .map!getTotient
    .sum();

  writeln(fractionCount);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
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

T getTotient(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  auto factorGroups = getPrimeFactorGroups(number);
  auto duplicateFactorProduct = factorGroups.map!(a => a[0] ^^ (a[1] - 1)).fold!((a, b) => a * b)(T(1));
  auto factors = factorGroups.map!(a => a[0]).array();
  T nonCoprimes = memoize!(getNonCoprimeCount!T)(factors);
  nonCoprimes *= duplicateFactorProduct;

  return number == 1 ? 1 : number - nonCoprimes;
}
*/
