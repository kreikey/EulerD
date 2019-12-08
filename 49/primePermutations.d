#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import kreikey.primes;
import kreikey.intmath;
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
  
  auto primePermutations = primes.save.find!(a => a > 999)
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
    .asort
    .uniq
    .map!(a => a, a => iota(1, a.length).retro()
        .map!(i => iota(i).retro()
          .map!(j => a[i] - a[j])
          .array())
        .join
        .asort())
    .cache
    .filter!(a => a[1].slide(2).canFind!(c => c[0] == c[1])() && a[1].canFind(3330))
    .map!(a => a[0].find!(b => a[0].canFind(b + 3330)).front)
    .map!(a => recurrence!((a, n) => a[n-1] + 3330)(a).take(3).array())
    .tee!(a => writefln("%(%s, %)", a))
    .array();

    primePermutations[$-1]
      .map!(toDigits)
      .join
      .toString
      .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
