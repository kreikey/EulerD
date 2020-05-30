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

  uint tot1;
  uint tot2;

  timer.start();

  //nTotientRatio[0] = primes
    //.cumulativeFold!((a, b) => a * b)
    //.until!(a => a > top)
    //.tail(1)
    //.front;

  //nTotientRatio[1] = nTotientRatio[0].totient();
  //nTotientRatio[2] = real(nTotientRatio[0])/nTotientRatio[1];

  foreach (n; 2..10000) {
    tot1 = totient2(n);
    //tot2 = totient2(n);
    //writefln("totient(%s): %s totient2(%s): %s", n, tot1, n, tot2);
    //assert(tot1 == tot2);
  }

  foreach (n; iota(2, 10000).retro()) {
    tot1 = totient2(n);
    //tot2 = totient2(n);
    //writefln("totient(%s): %s totient2(%s): %s", n, tot1, n, tot2);
    //assert(tot1 == tot2);
  }
    
  timer.stop();

  writefln("n with max totient(n)/n from 2 through %s is:\n%s; totient: %s; ratio: %s", top, nTotientRatio.expand);

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint totient(uint number) {
  uint coprimeCount = 0;

  if (number == 0)
    return 0;

  foreach (n; 1..number)
    coprimeCount += areCoprime(number, n);

  return coprimeCount;
}

uint totient2(uint number) {
  uint coprimeCount = number - 1;
  uint[] factors = distinctPrimeFactors(number).to!(uint[])();
  uint[] mask = new uint[factors.length];
  uint mainFactor;
  uint[] remainingFactors;

  foreach (k; iota(0, mask.length).retro()) {
    mask[k..$] = 1;
    do {
      mainFactor = 1 * zip(factors, mask).filter!(a => a[1]).map!(a => a[0]).fold!((a, b) => a * b)();
      remainingFactors = zip(factors, mask).filter!(a => a[1] == 0).map!(a => a[0]).array();
      coprimeCount -= exclusiveMultiples(number, mainFactor, remainingFactors);
    } while (nextPermutation(mask));
    mask[] = 0;
  }

  return coprimeCount;
}

uint exclusiveMultiples(uint number, uint factor, uint[] moreFactors) {
  uint multiples = (number - 1) / factor;
  uint[] mask = new uint[moreFactors.length];
  uint mainFactor;
  uint[] remainingFactors;

  foreach (k; iota(0, mask.length).retro()) {
    mask[k..$] = 1;
    do {
      mainFactor = factor * zip(moreFactors, mask).filter!(a => a[1]).map!(a => a[0]).fold!((a, b) => a * b)();
      remainingFactors = zip(moreFactors, mask).filter!(a => a[1] == 0).map!(a => a[0]).array();
      multiples -= exclusiveMultiples(number, mainFactor, remainingFactors);
    } while (nextPermutation(mask));
    mask[] = 0;
  }

  return multiples;
}
