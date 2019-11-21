#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;
import std.functional;
//import kreikey.stack;
import kreikey.combinatorics;
import std.datetime.stopwatch;

alias nextPermutation = kreikey.intmath.nextPermutation;
alias permutations = kreikey.combinatorics.permutations;
//alias permutations = std.algorithm.permutations;
bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto digits = iota!uint(1, 5).array();
  auto perms = permutations(digits).map!(a => a.array()).array();

  timer.start();

  writeln("The largest n-digit pandigital prime is:");

  getPandigitals.filter!(a => a.sum() % 3 != 0)
    .map!permutations
    .join
    .filter!(a => a[$-1] % 2 != 0 && a[$-1] != 5)
    .map!(toNumber!10)
    .array
    .asortDescending
    .find!isPrime
    .front
    .writeln();

  //auto pandigitals = getPandigitals.filter!(a => a.sum() % 3 != 0).array();
  //uint[][] permutations;
  //foreach (pandigital; pandigitals) {
    //do {
      //permutations ~= pandigital.dup;
    //} while (pandigital.nextPermutation());
  //}
  //permutations.filter!(a => a[$-1] % 2 != 0 && a[$-1] != 5)
    //.map!(toNumber!10)
    //.array
    //.asortDescending
    //.find!isPrime
    //.front
    //.writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] getPandigitals() {
  uint[] digits;
  uint[][] pandigitals;

  foreach (n; 3..11) {
    digits = iota!uint(1, n).array();
    pandigitals ~= digits;
  }

  return pandigitals;
}
