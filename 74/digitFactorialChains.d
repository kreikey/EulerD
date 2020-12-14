#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;
  ulong limit = 1000000;

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writeln("with 60 non-repeating terms is:");

  iota(1, limit)
    .map!factorialDigitChainLength
    .filter!(a => a == 60)
    .count()
    .writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong factorialDigitChainLength(ulong source) {
  ulong index = 0;
  ulong sum = source;
  ulong[ulong] factorialSumIndex = [sum:index];
  sum = factorialDigitSum(sum);
  index++;

  while (sum !in factorialSumIndex) {
    factorialSumIndex[sum] = index;
    sum = factorialDigitSum(sum);
    index++;
  }

  return index;
}

ulong factorialDigitSum(ulong source) {
  return source.toDigits.map!factorial.sum();
}
