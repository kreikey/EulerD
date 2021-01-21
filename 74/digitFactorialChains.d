#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1000000;
  int chainLength = 60;

  try {
    if (args.length > 1) {
      chainLength = args[1].parse!int();
    }
  } catch (Exception e) {
    writeln(e.msg);
    writeln("Can't parse that argument! Falling back to default.");
  }

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writefln("with %s non-repeating terms is:", chainLength);

  timer.start();

  iota(1, limit)
    .map!(a => a, factorialDigitChainLength)
    .filter!(a => a[1] == chainLength)
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
