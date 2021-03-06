#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;
typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto primes = new Primes!()();

  timer.start();
  writeln("Prime Permutations");
  
  primes
    .find!(a => a > 999)
    .until!(a => a > 9999)
    .map!(a => a.toDigits
        .permutations!uint
        .map!(a => cast(long)toNumber(a))
        .cache
        .filter!(a => a.isPrime() && a > 999)
        .array
        .sort
        .uniq
        .array())
    .cache
    .filter!(a => a.length > 2)
    .array
    .sort
    .uniq
    .filterBidirectional!(a => a.any!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))())
    .map!(a => a.find!(b => a.canFind(b + 3330) && a.canFind(b + 3330 * 2))
        .front
        .recurrence!((a, n) => a[n-1] + 3330)
        .take(3)
        .array())
    .back
    .map!toDigits
    .join
    .toString
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
