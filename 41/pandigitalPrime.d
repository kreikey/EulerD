#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.functional;
import std.datetime.stopwatch;
import kreikey.combinatorics;
import kreikey.intmath;
import kreikey.primes;
import kreikey.digits;

alias nextPermutation = kreikey.intmath.nextPermutation;
alias permutations = kreikey.combinatorics.permutations;
bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;

  timer.start();
  writeln("Pandigital prime");
  writeln("The largest n-digit pandigital prime is:");

  ulong number = getLargestPandigitalPrime();
  number.writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] getPandigitalsDescending() {
  return iota(9, 2, -1)
    .map!(a => iota!uint(a, 0, -1).array())
    .array();
}

ulong getLargestPandigitalPrime() {
  auto pandigitals = getPandigitalsDescending.filter!(a => a.sum() % 3 != 0).array();
  ulong number = 0;

  foreach (pandigital; pandigitals) {
    do {
      number = pandigital.toNumber();
      if (number.isPrime())
        return number;
    } while (pandigital.nextPermutation!((a, b) => a > b)());
  }

  return number;
}
