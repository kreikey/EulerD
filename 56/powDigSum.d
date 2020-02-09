#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.typecons;
import std.functional;
import kreikey.bigint;
import kreikey.intmath;

alias powerDigitSum = memoize!powerDigitSum1;

void main() {
  StopWatch timer;
  
  writeln("Power digit sum");
  timer.start();

  auto maxPow = iota(2, 100)
    .filter!(a => a % 10 != 0)
    .map!classifyPerfectPower
    .map!(a => iota(2, 100)
        .map!(b => a[0], b => b * a[1])
        .array())
    .join
    .map!(a => powerDigitSum(a.expand), a => a)
    .fold!max();

  auto maxDigSum = powerDigitSum(maxPow[1].expand);

  timer.stop();

  writefln("Power with max digit sum: %(%s^%s%)", maxPow[1]);
  writefln("Max digit sum: %s", maxDigSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong powerDigitSum1(ulong a, ulong b) {
  return (BigInt(a) ^^ b).toDigits.sum();
}
