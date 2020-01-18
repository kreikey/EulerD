#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.bytemath;
import kreikey.primes;
import std.functional;
import kreikey.combinatorics;
import std.datetime.stopwatch;

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

  getPandigitalsDescending
    .filter!(a => a.sum() % 3 != 0)
    .map!permutations
    .join
    .filter!(a => a[$-1] % 2 != 0 && a[$-1] != 5)
    .map!toNumber
    .array
    .asortDescending
    .find!isPrime
    .front
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] getPandigitalsDescending() {
  return iota(9, 2, -1)
    .map!(a => iota!uint(a, 0, -1).array())
    .array();
}
