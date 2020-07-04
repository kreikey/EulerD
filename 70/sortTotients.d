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
  ulong top = 9999999;
  ulong number;
  ulong totient;
  real ratio;
  ulong[] factors;

  timer.start();
  writeln("Totient permutation");

  auto numTotientRatios = File("totients.txt")
    .byLine
    .map!(a => a.split(" ").map!(to!ulong).array())
    .map!(a => a[0], a => a[1], a => real(a[0])/a[1])
    .array();

  numTotientRatios.sort!((a, b) => a[2] < b[2])();

  auto sortedTotientsFile = File("sortedTotients.txt", "w");
  numTotientRatios
    .each!(a => sortedTotientsFile.writefln!"%(%s %s %s%)"(a))();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}