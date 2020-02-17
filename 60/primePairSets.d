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
  ulong topSum = ulong.max;

  //auto outfile = File("output.txt", "w");

  writeln("Prime pair sets");
  timer.start();
  auto selectedPrimes = primes.filter!(a => a != 2 && a != 5)();
  primesMatrix ~= [selectedPrimes.front];
  selectedPrimes.popFront();
  
  do {
    foreach (ref row; primesMatrix) {
      if (row.all!(a => a.catsPrimeWith(selectedPrimes.front))()) {
        row ~= selectedPrimes.front;
        if (row.length == 5) {
          longestRows ~= row;
          finished = true;
          topSum = row.sum();
        }
        writeln(row);
      }
    }
    primesMatrix ~= [selectedPrimes.front];
    selectedPrimes.popFront();
  } while (!finished);

  auto limit = ceil(real(topSum) / 5).lrint();
  writeln();
  writeln("limit: ");
  writeln(limit);
  writeln();

  auto lastIdx = primesMatrix.countUntil!(a => a[0] > limit)();
  primesMatrix = primesMatrix[0 .. lastIdx + 1];

  do {
    finished = true;
    writefln("Prime: %s", selectedPrimes.front);
    foreach (ref row; primesMatrix) {
      if (row.length == 5)
        continue;
      else if ((row.sum() + selectedPrimes.front) < topSum)
        finished = false;
      if (row.all!(a => a.catsPrimeWith(selectedPrimes.front))()) {
        row ~= selectedPrimes.front;
        if (row.length == 5) {
          longestRows ~= row;
        }
        writeln(row);
      }
    }
    selectedPrimes.popFront();
  } while (!finished);
  writeln("finished");

  sums = longestRows.map!sum.array();
  total = sums.fold!max();

  //primesMatrix.each!(a => outfile.writeln(a))();
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
