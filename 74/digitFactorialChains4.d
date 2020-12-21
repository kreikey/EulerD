#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.functional;
import std.concurrency;
import std.typecons;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;
ulong[] specialCycleRoots = [169, 871, 872];

void main() {
  StopWatch timer;
  ulong limit = 1000000;

  timer.start();

  ulong[][] specialCycles = specialCycleRoots
    .map!factorialDigitChain
    .array();
  bool[uint[]] specialCycleMembers = specialCycles
    .join
    .map!(a => a.toDigits.permutations)
    .join
    .map!(a => cast(const(uint)[])a)
    .zip(repeat(true))
    //.tee!writeln
    .assocArray();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writeln("with 60 non-repeating terms is:");

  auto maxDigs = (limit - 1).countDigits();
  
  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit(1, maxDigs));
  sortedDigits
    .filter!(a => a !in specialCycleMembers)
    .map!(a => a, factorialDigitChainLength)
    .filter!(a => a[1] == 60)
    .tee!(a => writefln("%(%s %s%)", a))
    .map!(a => a[0].dup)
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

ulong[] factorialDigitChain(ulong source) {
  ulong[] chain;
  ulong index = 0;
  ulong[ulong] factorialSumIndex = [source:index];
  ulong sum = source.toDigits.map!factorial.sum();
  index++;

  chain ~= source;

  while (sum !in factorialSumIndex) {
    chain ~= sum;
    factorialSumIndex[cast(immutable)sum] = index;
    sum = sum.toDigits.map!factorial.sum();
    index++;
  }

  return chain;
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

