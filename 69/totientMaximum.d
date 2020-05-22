#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.typecons;
import kreikey.intmath;
import kreikey.primes;

void main() {
  StopWatch timer;
  Tuple!(real, uint) maxNOverTotientN = tuple(0, 0);
  uint number = 0;
  uint top = 1_000_000;
  auto primes = new Primes!uint();

  timer.start();

  number = primes
    .cumulativeFold!((a, b) => a * b)
    .until!(a => a > top)
    .tail(1)
    .front;

  maxNOverTotientN[0] = real(number)/number.totient();
  maxNOverTotientN[1] = number;

  timer.stop();

  writefln("max n/totient(n) from 2 through %s is: %s; n: %s", top, maxNOverTotientN.expand);

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint totient(uint number) {
  uint coprimeCount = 0;
  Tuple!(uint, uint)[uint[]] maxByDistinctPrimeFactors;
  uint[] factors;
  Tuple!(uint, uint)* lowerPtr;
  Tuple!(uint, uint) lower;

  if (number == 0)
    return 0;

  factors = number.distinctPrimeFactors.to!(uint[])();
  lowerPtr = factors in maxByDistinctPrimeFactors;
  lower = lowerPtr == null ? tuple(0u, 0u) : *lowerPtr;

  coprimeCount = lower[1];

  foreach (n; lower[0]+1..number)
    coprimeCount += areCoprime(number, n);

  maxByDistinctPrimeFactors[cast(immutable)factors] = tuple(number, coprimeCount);

  return coprimeCount;
}
