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

  timer.start();
  writeln("Totient permutation");

  auto numbers = File("numbers2.txt")
    .byLine
    .map!(to!ulong)
    .array();

  numbers.sort();

  auto sortedNumbersFile = File("sortedNumbers.txt", "w");
  numbers.each!(a => sortedNumbersFile.writeln(a))();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
