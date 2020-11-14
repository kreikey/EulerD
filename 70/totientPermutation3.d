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
typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto totientPairs = new Generator!(Tuple!(ulong, ulong))(getMultiTotientsInit(10000000));

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
