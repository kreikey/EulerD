#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.functional;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;
  ulong limit = 1000000;
  int chainLength = 60;

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writeln("with 60 non-repeating terms is:");

  // this algorithm is not correct for the general case

  iota(1, limit)
    .map!(a => a.toDigits.asort())
    .map!(memoize!factorialDigitChainLength)
    .filter!(a => a == chainLength)
    .count()
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
