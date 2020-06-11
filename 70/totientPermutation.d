#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;
import kreikey.digits;
import kreikey.primes;

alias isPermutation = kreikey.combinatorics.isPermutation;

// number: 9983167 totient: 9973816 ratio: 1.00094

void main() {
  StopWatch timer;
  ulong top = 1000000;

  timer.start();
  writeln("Totient permutation");

  printTotients(top);
  //writefln("number: %s totient: %s ratio: %s", result.expand, real(result[0])/result[1]);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto getTotientPermutation(ulong top) {
  auto primes = new Primes!ulong();
  ulong product;
  ulong totient;

  for (ulong low = primes.countUntil!(a => a >= sqrt(real(top)))() - 1; low < ulong.max; low--) {
    writeln(primes.front);
    for (ulong high = primes.countUntil!(a => a >= real(top)/primes[low])() - 1; high > low; high--) {
      product = primes[low] * primes[high];
      totient = getTotient(product);
      writeln(primes[low], " ", primes[high], " ", product, " ", totient, " ", real(product)/totient);
      if (isPermutation(product, totient))
        return tuple(product, totient);
    }
  }

  return tuple(0uL, 0uL);
}

void printTotients(ulong upper) {
  auto primes = new Primes!ulong();
  //auto primeIndexes = primes.cumulativeFold!((a, b) => a * b).until!(a => a >= upper).enumerate.map!(a => a[0]).array();
  //writeln(primeIndexes.map!(a => primes[a]));
  ulong bigNdx = 0;
  ulong[] pNdxs = [bigNdx];

  void inner(ulong[] pNdxs) {
    ulong number;
    ulong totient;
    //number = pNdxs.map!(a => primes[a]).fold!((a, b) => a * b)();
    //writeln(pNdxs);
    writeln(pNdxs.map!(a => primes[a])());
    if (pNdxs.chain(only(pNdxs[$-1] + 1)).map!(a => primes[a]).fold!((a, b) => a * b)() < upper) {
      //writeln(pNdxs.map!(a => primes[a])());
      inner(pNdxs ~ (pNdxs[$-1] + 1uL));
    }
    //totient = getTotient(number);
    //writefln("number: %s totient: %s", number, totient);
  }
  
  inner(pNdxs);
}
