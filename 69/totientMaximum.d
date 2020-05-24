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
  Tuple!(uint, uint, real) nTotientRatio = tuple(0, 0, 0);
  uint top = 1_000_000;
  auto primes = new Primes!uint();

  timer.start();

  nTotientRatio[0] = primes
    .cumulativeFold!((a, b) => a * b)
    .until!(a => a > top)
    .tail(1)
    .front;

  nTotientRatio[1] = nTotientRatio[0].totient();
  nTotientRatio[2] = real(nTotientRatio[0])/nTotientRatio[1];

  foreach (n; 2..50000) {
    if (n % 1000 == 0)
      writeln(n, ": ", totient(n));
    totient(n);
  }

  timer.stop();

  writefln("n with max totient(n)/n from 2 through %s is:\n%s; totient: %s; ratio: %s", top, nTotientRatio.expand);

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint totient(uint number) {
  uint coprimeCount = 0;
  //Tuple!(uint, uint)[uint[]] maxByDistinctPrimeFactors;
  static Tuple!(uint, uint)[uint[]] maxByDistinctPrimeFactors;
  uint[] factors;
  Tuple!(uint, uint)* lowerPtr;
  Tuple!(uint, uint) lower;

  if (number == 0)
    return 0;

  factors = number.distinctPrimeFactors.to!(uint[])();
  lowerPtr = factors in maxByDistinctPrimeFactors;
  //writefln("\t%s", lowerPtr);
  lower = lowerPtr == null ? tuple(0u, 0u) : *lowerPtr;

  coprimeCount = lower[1];

  foreach (n; lower[0]+1..number)
    coprimeCount += areCoprime(number, n);

  maxByDistinctPrimeFactors[cast(immutable)factors] = tuple(number, coprimeCount);

  return coprimeCount;
}
