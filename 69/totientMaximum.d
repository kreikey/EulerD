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
  Tuple!(ulong, ulong, real) nTotientRatio = tuple(0, 0, 0);
  ulong top = 1_000_000;
  auto primes = new Primes!ulong();

  timer.start();
  writeln("Totient maximum");

  nTotientRatio[0] = primes
    .cumulativeFold!((a, b) => a * b)
    .until!(a => a > top)
    .tail(1)
    .front;

  nTotientRatio[1] = totient(nTotientRatio[0]);
  nTotientRatio[2] = real(nTotientRatio[0])/nTotientRatio[1];

  timer.stop();
  writefln("n with max totient(n)/n from 2 through %s is:\n%s; totient: %s; ratio: %s", top, nTotientRatio.expand);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
ulong totient(ulong number) {
  ulong[] factors = distinctPrimeFactors(number);

  ulong exclusiveMultiples(ulong factor, ulong[] moreFactors) {
    ulong multiples = (number - 1) / factor;
    ulong[] mask = new ulong[moreFactors.length];
    ulong mainFactor;
    ulong[] chosenFactors;
    ulong[] remainingFactors;

    void separate(out ulong[] chosenFactors, out ulong[] remainingFactors) {
      for (ulong i = 0; i < moreFactors.length; i++) {
        if (mask[i])
          chosenFactors ~= moreFactors[i];
        else
          remainingFactors ~= moreFactors[i];
      }
    }

    foreach (k; iota(0, mask.length).retro()) {
      mask[k..$] = 1;
      do {
        separate(chosenFactors, remainingFactors);
        mainFactor = only(factor).chain(chosenFactors).fold!((a, b) => a * b)();
        multiples -= exclusiveMultiples(mainFactor, remainingFactors);
      } while (nextPermutation(mask));
      mask[] = 0;
    }

    return multiples;
  }

  return exclusiveMultiples(1, factors);
}
*/
