#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.typecons;
import std.functional;
import kreikey.intmath;
import kreikey.primes;
import kreikey.util;

//alias distinctPrimeFactors = kreikey.intmath.distinctPrimeFactors1;

void main() {
  StopWatch timer;
  Tuple!(real, uint) maxNOverTotientN = tuple(0, 0);
  real nOverTotient;
  uint number = 0;
  uint[][uint] numbersByFactor;
  uint[] numbersSharingPrimeFactors;
  uint[] coprimes;
  uint coprimeCount;
  uint top = 1_000_001;

  timer.start();

  foreach (n; 2..top) {
    coprimeCount = totient(n);
    if (n % 10000 == 0)
      writefln("n: %s, totient: %s", n, coprimeCount);
    nOverTotient = real(n)/coprimeCount;
    if (nOverTotient > maxNOverTotientN[0]) {
      maxNOverTotientN[0] = nOverTotient;
      maxNOverTotientN[1] = n;
    }
  }

  timer.stop();

  writefln("max n/totient(n) from 2 through %s is: %s; n: %s", top - 1, maxNOverTotientN[0], maxNOverTotientN[1]);

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

  //writefln("number: %s", number);
  factors = number.distinctPrimeFactors.to!(uint[])();
  //writeln(factors);
  lowerPtr = factors in maxByDistinctPrimeFactors;
  //writeln(lowerPtr);
  lower = lowerPtr == null ? tuple(0u, 0u) : *lowerPtr;
  //writeln(lower);

  coprimeCount = lower[1];

  foreach (n; lower[0]+1..number) {
    coprimeCount += areCoprime(number, n);
  }

  maxByDistinctPrimeFactors[cast(immutable)factors] = tuple(number, coprimeCount);

  return coprimeCount;
}

//bool areCoprime(ulong a, ulong b) {
  //bool inner(ulong[] a, ulong[] b) {
    //return setIntersection(a, b).count() == 0;
  //}

  //auto factorsA = distinctPrimeFactors(a);
  //auto factorsB = distinctPrimeFactors(b);
  //if (factorsA < factorsB)
    //swap(factorsA, factorsB);

  //return memoize!inner(factorsA, factorsB);
//}

//ulong[] distinctPrimeFactors(ulong source) {
  //return primeFactors(source).uniq.array();
//}
