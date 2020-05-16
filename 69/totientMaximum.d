#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.typecons;
import kreikey.intmath;
import kreikey.primes;
import kreikey.util;

void main() {
  StopWatch timer;
  Tuple!(real, uint) maxNOverTotientN;
  real nOverTotient;
  ulong number = 0;
  int[][ulong] numbersByFactor;
  int[] numbersSharingPrimeFactors;
  int[] coprimes;
  ulong coprimeCount;

  timer.start();

  writeln("building numbersByFactor from 2 through 1,000,000");
  foreach (n; 2..1_000_001) {
    foreach (f; distinctPrimeFactors(n)) {
      numbersByFactor[f] ~= n;
    }
  }

  writeln("finished building numbersByFactor");
  
  foreach (n; 2..1_000_001) {
    numbersSharingPrimeFactors = n.distinctPrimeFactors.map!(a => numbersByFactor[a].filter!(a => a < n).array()).array.multiwayUnion.array();
    coprimeCount = setDifference(iota(1, n), numbersSharingPrimeFactors).count();
    writeln(coprimeCount);
    nOverTotient = real(n)/coprimeCount;
    if (nOverTotient > maxNOverTotientN[0]) {
      maxNOverTotientN[0] = nOverTotient;
      maxNOverTotientN[1] = n;
    }
    numbersSharingPrimeFactors = [];
  }

  timer.stop();

  writefln("max n/totient(n) from 2 through 1,000,000 is: %s; n: %s", maxNOverTotientN.expand);

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong totient(ulong number) {
  ulong coprimeCount = 0;

  foreach (n; iota(1, number).retro()) {
    coprimeCount += number.areCoprime(n);
  }

  return coprimeCount;
}

