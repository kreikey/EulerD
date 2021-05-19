#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.functional;
import std.traits;
import kreikey.digits;
import kreikey.primes;

alias catsPrimeWith = memoize!catsPrimeWith1;
ReturnType!(isPrimeInit!ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main(string[] args) {
  StopWatch timer;
  ulong biggestSum = 107623;
  //ulong biggestSum = ulong.max;

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
      writeln(cattables);
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

bool catsPrimeWith1(ulong left, ulong right) {
  ulong cat1 = toNumber(left.toDigits ~ right.toDigits);

  if (!cat1.isPrime())
    return false;

  ulong cat2 = toNumber(right.toDigits() ~ left.toDigits);

  if (!cat2.isPrime())
    return false;

  return true;
}
