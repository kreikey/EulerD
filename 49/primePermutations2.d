#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.primes;
import kreikey.intmath;
import kreikey.combinatorics;
import kreikey.linkedlist;

alias permutations = kreikey.combinatorics.permutations;
typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto primes = new Primes!()();
  ulong[][] primePermutations;
  ulong cur;

  timer.start();
  writeln("Prime Permutations");
  
  auto primesList = primes
    .find!(a => a > 999)
    .until!(a => a > 9999)
    .toLinkedList();

  do {
    cur = primesList.removeCur();
    primePermutations ~= [cur];

    foreach (p; primesList) {
      if (isPermutation(cur, p)) {
        primePermutations[$-1] ~= primesList.removeCur();
      }
    }

    if (!primesList.empty)
      primesList.getFirst();
  } while (!primesList.empty());

  primePermutations
    .filterBidirectional!(a => a.any!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))())
    .map!(a => a.find!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))
        .front
        .recurrence!((a, n) => a[n-1] + 3330)
        .take(3)
        .array())
    .back
    .map!(to!string)
    .join
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
