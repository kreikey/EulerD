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

void main() {
  StopWatch timer;

  timer.start();
  writeln("Totient permutation");

  auto tumber = findTotientPermutation(10000000);
  writefln("number: %s totient: %s ratio: %s", tumber.expand);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto findTotientPermutation(ulong top) {
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
      writefln("t(%s) = %s ratio: %s", number, totient, ratio);
      minRatio = ratio;
      bestNumber = number;
      bestTotient = totient;
    }

    foreach (offset, factor; currentFactors.enumerate(1).retro())
      if (inner(factors ~ factor, index + offset))
        break;

    return ratio > minRatio;
  }

  auto initialNumbers = primes
    .save
    .until!(a => a > sqrt(real(top)))
    .array();
  
  foreach (index, initial; initialNumbers.enumerate(1).retro())
    inner([initial], index);

  return tuple(bestNumber, bestTotient, minRatio);
}
