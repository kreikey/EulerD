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

  timer.start();

  writeln("The largest n-digit pandigital prime is:");

  auto pandigitals = getPandigitalsDescending.filter!(a => a.sum() % 3 != 0).array();
  uint[][] perms;
  bool done = false;
  ulong number;

  foreach (pandigital; pandigitals) {
    do {
      writeln(pandigital);
      number = pandigital.toNumber();
      if (number.isPrime()) {
        done = true;
      }
    } while (pandigital.nextPermutation!((a, b) => a > b)() && !done);
    if (done)
      break;
  }

  number.writeln();

  //getPandigitals
    //.filter!(a => a.sum() % 3 != 0)
    //.map!permutations
    //.join
    //.filter!(a => a[$-1] % 2 != 0 && a[$-1] != 5)
    //.map!toNumber
    //.array
    //.asortDescending
    //.find!isPrime
    //.front
    //.writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] getPandigitals() {
  return iota(3, 11)
    .map!(a => iota!uint(1, a).array)
    .array();
}

uint[][] getPandigitalsDescending() {
  return iota(9, 2, -1)
    .map!(a => iota!uint(a, 0, -1).array())
    .array();
}