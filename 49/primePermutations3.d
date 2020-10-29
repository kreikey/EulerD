#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.primes;
import kreikey.intmath;
//import kreikey.bytemath;
import kreikey.digits;
import kreikey.util;
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
  
  auto primesArray = primes
    .find!(a => a > 999)
    .until!(a => a > 9999)
    .array();

  primePermutations = primesArray
    .map!(a => a, a => a.toDigits.asort())
    .array()
    .sort!((a, b) => a[1] < b[1])
    .chunkBy!((a, b) => a[1] == b[1])
    .map!(a => a.map!(b => b[0])
        .array())
    .array();

  primePermutations = primePermutations
    .filter!(a => a.any!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))())
    .map!(a => a.find!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))
        .front
        .recurrence!((a, n) => a[n-1] + 3330)
        .take(3)
        .array())
    .array();

  primePermutations
    .each!writeln();

  primePermutations[1]
    .map!(to!string)
    .join
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
