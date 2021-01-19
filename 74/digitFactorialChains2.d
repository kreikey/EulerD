#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;

void main() {
  StopWatch timer;
  ulong limit = 1000000;

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writeln("with 60 non-repeating terms is:");

  // Correct for chain length 60, but not in the general case

  iota(1, limit)
    .map!(a => a.toDigits.asort())
    .array
    .sort
    .uniq
    .filter!(a => factorialDigitChainLength(a) == 60)
    .map!permutations
    .join
    .sort
    .uniq
    .filter!(a => a[0] != 0)
    .count
    .writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong factorialDigitChainLength(uint[] source) {
  ulong index = 0;
  ulong[uint[]] factorialSumIndex = [source:index];
  uint[] sumDigs = source.factDigSumDigs();
  index++;

  while (sumDigs !in factorialSumIndex) {
    factorialSumIndex[cast(immutable)sumDigs] = index;
    sumDigs = sumDigs.factDigSumDigs();
    index++;
  }

  return index;
}

uint[] factDigSumDigs(uint[] source) {
  return source.map!factorial.sum.toDigits();
}
