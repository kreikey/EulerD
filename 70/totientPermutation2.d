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
typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

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

  for (ulong low = primes.countUntil!(a => a >= sqrt(real(top)))() - 1; low < ulong.max; low--) {
    primes[low];
    for (ulong high = low + primes.countUntil!(a => a >= real(top)/primes[low])() - 1; high > low; high--) {
      number = primes[low] * primes[high];
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
  }

  return tuple(bestProduct, bestTotient);
}
