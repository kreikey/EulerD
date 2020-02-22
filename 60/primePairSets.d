#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.array;
import std.conv;
import std.traits;
import std.functional;
import std.math;
import std.file;
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;

alias catsPrimeWith = memoize!catsPrimeWith1;
//alias catsPrimeWith = catsPrimeWith1;
ReturnType!isPrimeInit isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  timer.start();
  writefln("Prime pair sets");
  ulong biggestSum = 107623;
  auto result = primePairSets(5, biggestSum);
  result.each!writeln();
  ulong smallestSum = result.map!sum.fold!min();
  timer.stop();
  writeln("The lowest sum for a set of five primes for which any two primes concatenate to produce another prime is:");
  writeln(smallestSum);
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

bool catsPrimeWith1(ulong left, ulong right) {
  ulong cat1 = toNumber(left.toDigits ~ right.toDigits);

  if (!cat1.isPrime())
    return false;

  ulong cat2 = toNumber(right.toDigits() ~ left.toDigits);

  if (!cat2.isPrime())
    return false;

  return true;
}

ulong getUpperBound() {
  ulong[][] primesMatrix = [][];
  ulong[] longestRow;
  auto primes = new Primes!ulong();
  bool finished = false;

  auto selectedPrimes = primes.filter!(a => a != 2 && a != 5)();
  primesMatrix ~= [selectedPrimes.front];
  selectedPrimes.popFront();
  
  do {
    foreach (ref row; primesMatrix) {
      if (row.all!(a => a.catsPrimeWith(selectedPrimes.front))()) {
        row ~= selectedPrimes.front;
        if (row.length == 5) {
          longestRow ~= row;
          finished = true;
          break;
        }
      }
    }
    primesMatrix ~= [selectedPrimes.front];
    selectedPrimes.popFront();
  } while (!finished);
  return longestRow.sum();
}
