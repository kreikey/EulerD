#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.functional;
import std.datetime.stopwatch;
import std.traits;
import kreikey.primes;
import common;

void main() {
  StopWatch timer;
  timer.start();
  writeln("Getting an upper bound for Prime Pair Sets.");
  writeln("Please wait about 3 minutes.");
  writeln(getUpperBound());
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
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

