#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.concurrency;
import std.typecons;
import kreikey.intmath;
import kreikey.combinatorics;

alias isPermutation = kreikey.combinatorics.isPermutation;

void main() {
  StopWatch timer;
  auto totientPairs = new Generator!(Tuple!(ulong, ulong))(multiTotientsInit!ulong(10000000));

  timer.start();
  writeln("Totient permutation");

  auto tumber = totientPairs
    .dropOne
    .filter!(a => isPermutation(a.expand))
    .map!(a => a[0], a => a[1], a => real(a[0])/a[1])
    .fold!((a, b) => a[2] < b[2] ? a : b)();

  writefln("number: %s totient: %s ratio: %s", tumber.expand);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
auto multiTotientsInit(T)(T topNumber) if (isIntegral!T) {
  assert (topNumber > 0);
  void getMultiTotients() {
    T[] factors = makePrimes!T
      .until!((a, b) => a >= b)(topNumber)
      .array();

    void inner(T baseNumber, T multiplier, T[] someFactors, T[] distinctFactors) {
      T totient = multiplier * (baseNumber - memoize!(getNonCoprimeCount!T)(distinctFactors[1 .. $]));

      yield(tuple(T(baseNumber * multiplier), T(totient)));

      foreach (i, f; someFactors) {
        if (baseNumber * multiplier * f > topNumber)
          break;

        if (f == distinctFactors[$-1])
          inner(baseNumber, multiplier * f, someFactors[i .. $], distinctFactors);
        else
          inner(baseNumber * f, multiplier, someFactors[i .. $], distinctFactors ~ f);
      }
    }

    inner(1, 1, factors, [1]);
  }

  return &getMultiTotients;
}
*/
