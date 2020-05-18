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
  ulong number = 0;
  int[][ulong] numbersByFactor;
  int[] numbersSharingPrimeFactors;
  int[] coprimes;
  ulong coprimeCount;
  ulong top = 10001;

  timer.start();

  //writeln("building numbersByFactor from 2 through 1,000,000");
  //foreach (n; 2..1_000_001) {
    //foreach (f; distinctPrimeFactors(n)) {
      //numbersByFactor[f] ~= n;
    //}
  //}

  //writeln("finished building numbersByFactor");
  
  foreach (n; 2..100001) {
    //numbersSharingPrimeFactors = n.distinctPrimeFactors.map!(a => numbersByFactor[a].filter!(a => a < n).array()).array.multiwayUnion.array();
    //coprimeCount = setDifference(iota(1, n), numbersSharingPrimeFactors).count();
    //writeln(coprimeCount);
    coprimeCount = totient(n);
    //writefln("n: %s, totient: %s", n, coprimeCount);
    nOverTotient = real(n)/coprimeCount;
    if (nOverTotient > maxNOverTotientN[0]) {
      maxNOverTotientN[0] = nOverTotient;
      maxNOverTotientN[1] = n;
    }
    //numbersSharingPrimeFactors = [];
  }

  timer.stop();

  writefln("max n/totient(n) from 2 through %s is: %s; n: %s", top - 1, maxNOverTotientN[0], maxNOverTotientN[1]);

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong totient(ulong number) {
  ulong coprimeCount = 0;

  foreach (n; 1..number) {
    coprimeCount += areCoprime(number, n);
  }

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
