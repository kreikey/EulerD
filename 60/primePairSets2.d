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

void main() {
  StopWatch timer;
  auto p = new Primes!()();

  timer.start();

  writefln("Prime pair sets");
  writeln("Please wait about 1.5 minutes");

  auto result = smallestPrimePairSet(5);
  writeln("The lowest sum for a set of five primes for which any two primes concatenate to produce another prime is:");
  writeln(result.sum());

  timer.stop();

  ulong smallestSum = 0;

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto smallestPrimePairSet(ulong length) {
  ulong[] result;
  auto primes = new Primes!()();
  auto primesList = primes.take(5).array();
  ulong biggestSum = ulong.max;
  ulong[][ulong] cattablesTable;
  ulong topPrime = primesList[$-1];
  ulong[] cattables;

  ulong[] getCattables(ulong key) {
    ulong[]* result = key in cattablesTable;
    if (result != null)
      return *result;
    
    return [];
  }

  void inner(ulong[] cattablesFound, ulong[] localPrimes, ulong depth) {
    ulong catsum;
    if (depth == length) {
      writeln(cattablesFound);
      catsum = cattablesFound.sum();
      if (catsum < biggestSum) {
        biggestSum = catsum;
      }
      result = cattablesFound;
      return;
    }

    foreach (p; localPrimes) {
      if (cattablesFound.map!(a => getCattables(a)).join.count(p) == depth) {
        inner(cattablesFound ~ p, getCattables(p), depth + 1);
      }
      if (catsum + p * (length - depth) > biggestSum)
        break;
    }
  }

  do {
    foreach (p; primesList) {
      inner([p], getCattables(p), 1);
      if (p >= biggestSum / length)
        break;
    }

    primesList ~= primes.front;
    topPrime = primes.front;
    //writeln(topPrime);
    primes.popFront();

    foreach (p; primesList[0..$-1]) {
      if (p.catsPrimeWith(topPrime)) {
        cattablesTable[p] ~= topPrime;
      }
    }
  } while (result.length == 0);

  return result;
}
