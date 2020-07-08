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

  auto tumber = findTotientPermutation(top, sqrt(real(top)).to!ulong());
  number = tumber[0];
  totient = tumber[1];
  ratio = real(number)/totient;

  writefln("number: %s totient: %s ratio: %s", number, totient, ratio);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto findTotientPermutation(ulong top, ulong topFactor) {
  auto primes = new Primes!ulong();
  real minRatio = real.max;
  ulong bestNumber = top;
  ulong bestTotient = 0;

  bool inner(ulong[] factors, ulong index) {
    ulong number = factors.fold!((a, b) => a * b)(1uL);
    primes[index];
    auto currentFactors = primes
      .until!(a => a >= real(top)/number)
      .array();
    auto totient = getTotient(number);
    auto ratio = real(number)/totient;

    if (totient.isPermutation(number) && ratio < minRatio) {
      writefln("%s, %s, %s", number, totient, ratio);
      minRatio = ratio;
      bestNumber = number;
      bestTotient = totient;
    }

    foreach (offset, factor; currentFactors.enumerate.retro())
      if (inner(factors ~ factor, index + offset))
        break;

    return ratio > minRatio;
  }

  auto initialNumbers = primes
    .save
    .until!(a => a > topFactor)
    .array();
  
  foreach (index, initial; initialNumbers.enumerate.retro())
    inner([initial], index);

  return tuple(bestNumber, bestTotient);
}

void findTotientPermutation(ulong upper) {
  findTotientPermutation(upper, upper);
}
