#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import std.traits;
import std.conv;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;
import kreikey.digits;
import kreikey.primes;

alias isPermutation = kreikey.combinatorics.isPermutation;

// number: 9983167 totient: 9973816 ratio: 1.00094

void main() {
  StopWatch timer;
  ulong top = 10000000;
  ulong number;
  ulong totient;
  real ratio;
  ulong[] factors;

  timer.start();
  writeln("Totient permutation");

  auto tumber = findTotientPermutation(top);
  number = tumber[0];
  totient = tumber[1];
  ratio = real(number)/totient;

  writefln("number: %s totient: %s ratio: %s", number, totient, ratio);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto findTotientPermutation(ulong top) {
  auto primes = new Primes!ulong();
  ulong number;
  ulong totient;
  ulong bestProduct;
  ulong bestTotient;
  real smallestRatio = real.max;
  real ratio;
  ulong highNdx;
  ulong lowPrime;

  for (ulong lowNdx = primes.countUntil!(a => a >= sqrt(real(top)))() - 1; lowNdx < ulong.max; lowNdx--) {
    lowPrime = primes[lowNdx];
    primes.reindex();
    highNdx = lowNdx + primes.countUntil!(a => a >= real(top)/lowPrime)() - 1;
    primes.reset();
    //writeln(low, " ", high, " ", primes[low], " ", primes[high], " ", primes[low] * primes[high]);
    for (; highNdx > lowNdx; highNdx--) {
      number = primes[lowNdx] * primes[highNdx];
      totient = getTotient(number);
      ratio = real(number)/totient;

      if (ratio > smallestRatio)
        break;

      if (totient.isPermutation(number) && ratio < smallestRatio) {
        writefln("%s, %s, %s", number, totient, ratio);
        smallestRatio = ratio;
        bestProduct = number;
        bestTotient = totient;
      }
    }
    //writeln(primes[0]);
  }

  return tuple(bestProduct, bestTotient);
}
