#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.file;
import kreikey.primes;
import common;

void main(string[] args) {
  StopWatch timer;
  ulong biggestSum = 107623;

  if (args.length > 1) {
    biggestSum = args[1].to!ulong();
  }

  timer.start();

  writefln("Prime pair sets");
  writefln("Using %s as an upper bound.", biggestSum);

  auto result = primePairSets(5, biggestSum);

  timer.stop();

  ulong smallestSum = 0;

  if (result.length == 0) {
    writeln("No results found. Try a higher upper bound.");
  } else {
    writeln("results:");
    result.each!writeln();
    smallestSum = result.back.sum;
    writeln("The lowest sum for a set of five primes for which any two primes concatenate to produce another prime is:");
    writeln(smallestSum);
  }

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto primePairSets(ulong length, ulong biggestSum) {
  ulong[][] result;
  alias PrimesRange = Primes!ulong;
  auto primes = new PrimesRange();
  PrimesRange primesCopy;

  void inner(ulong[] cattables, PrimesRange primes, ulong depth) {
    ulong catsum = cattables.sum();
    if (depth == length) {
      if (catsum < biggestSum)
        biggestSum = catsum;
      result ~= cattables;
      return;
    }

    foreach (p; primes.until!(a => catsum + a * (length - depth) > biggestSum)) {
      if (cattables.all!(a => a.catsPrimeWith(p))()) {
        primesCopy = primes.save;
        primesCopy.popFront();
        inner(cattables ~ p, primesCopy, depth + 1);
      }
    }
  }

  foreach (p; primes.until!(a => a >= biggestSum / length)()) {
    primesCopy = primes.save;
    primesCopy.popFront();
    inner([p], primesCopy, 1);
  }

  return result;
}
