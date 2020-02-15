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
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;

alias catsPrimeWith = memoize!catsPrimeWith1;
ReturnType!isPrimeInit isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  ulong[][] primesMatrix = [][];
  ulong[][] longestRows;
  ulong[] longestRow;
  auto primes = new Primes!ulong();
  bool finished = false;
  bool stopAppending = false;
  ulong[] sums = [];
  ulong total = 0;
  ulong topSum = 0;

  writeln("Prime pair sets");
  timer.start();
  auto selectedPrimes = primes.filter!(a => a != 2 && a != 5)();
  primesMatrix ~= [selectedPrimes.front];
  selectedPrimes.popFront();
  
  do {
    foreach (ref row; primesMatrix) {
      if ((topSum == 0 || (row.sum + selectedPrimes.front) < topSum) && row.all!(a => a.catsPrimeWith(selectedPrimes.front))()) {
        row ~= selectedPrimes.front;
        if (row.length == 5) {
          longestRows ~= row;
          finished = true;
          topSum = row.sum();
        }
        writeln(row);
      }
    }
    if (!finished) {
      primesMatrix ~= [selectedPrimes.front];
    }
    selectedPrimes.popFront();
  } while (!finished);

  auto limit = ceil(real(topSum) / 5).lrint();
  writeln();
  writeln("limit: ");
  writeln(limit);
  writeln();

  auto lastIdx = primesMatrix.countUntil!(a => a[0] >= limit)();
  primesMatrix = primesMatrix[0 .. lastIdx];

  do {
    finished = true;
    writeln("looping");
    foreach (ref row; primesMatrix) {
      if (row.all!(a => a.catsPrimeWith(selectedPrimes.front))()) {
        row ~= selectedPrimes.front;
        if (row.length == 5) {
          longestRows ~= row;
        }
        writeln(row);
      }
      if ((row.sum() + selectedPrimes.front) < topSum)
        finished = false;
    }
    selectedPrimes.popFront();
  } while (!finished);
  writeln("finished");

  sums = longestRows.map!sum.array();
  total = sums.fold!max();

  primesMatrix.each!writeln();
  writeln("Longest rows:");
  writeln(longestRows);

  timer.stop();
  writeln("The lowest sum for a set of five primes for which any two concatenate to a prime is:");
  writeln(total);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
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
