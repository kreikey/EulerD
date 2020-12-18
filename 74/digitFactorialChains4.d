#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.functional;
import std.concurrency;
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

  auto length = (limit - 1).countDigits();

  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit(1, length));
  sortedDigits
    //.tee!writeln
    .map!(a => a.dup)
    .map!(a => a, factorialDigitChainLength)
    //.tee!(a => writefln("%(%s %s%)", a))
    .filter!(a => a[1] == 60)
    .tee!(a => writefln("%(%s %s%)", a))
    .map!(a => a[0])
    .map!permutations
    .join
    .array
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
  ulong[uint[]] factorialSumIndex = [source.dup:index];
  uint[] sumDigs = source.dup.factDigSumDigs();
  index++;

  while (sumDigs !in factorialSumIndex) {
    factorialSumIndex[cast(immutable)sumDigs] = index;
    sumDigs = sumDigs.factDigSumDigs();
    index++;
  }

  return index;
}

uint[] factDigSumDigs(uint[] source) {
  return source.dup.map!factorial.sum.toDigits();
}

