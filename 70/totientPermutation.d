#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import kreikey.intmath;
import kreikey.combinatorics;
import kreikey.digits;
import kreikey.primes;

alias isPermutation = kreikey.combinatorics.isPermutation;

// number: 9983167 totient: 9973816 ratio: 1.00094

void main() {
  StopWatch timer;
  ulong top = 10000000;

  timer.start();
  writeln("Totient permutation");

  //auto n1 = 87109;
  //auto t1 = totient(n1);
  //writefln("totient(%s): %s", n1, t1);
  //auto factors = primeFactors(n1);
  //writefln("factors of %s: %s", n1, factors);
  //writefln("%s is a permutation of %s: %s", t1, n1, isPermutation(t1, n1));
  //writefln("%s/totient(%s): %s", n1, n1, real(n1)/t1);
  //writeln(9983167);
  //writeln(distinctPrimeFactors(9983167));

  auto result = getTotientPermutation(top);

  writefln("number: %s totient: %s ratio: %s", result.expand, real(result[0])/result[1]);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto getTotientPermutation(ulong top) {
  auto primes = new Primes!ulong();
  primes.reset();
  ulong product;
  ulong totient1;

  for (ulong low = primes.countUntil!(a => a >= sqrt(real(top)))() - 1; low < ulong.max; low--) {
    primes.reset();
    for (ulong high = primes.countUntil!(a => a >= real(top)/primes[low])() - 1; high > low; high--) {
      product = primes[low] * primes[high];
      totient1 = totient(product);
      writeln(primes[low], " ", primes[high], " ", product, " ", totient1, " ", real(product)/totient1);
      if (isPermutation(product, totient1))
        return tuple(product, totient1);
    }
  }

  return tuple(0uL, 0uL);
}  
