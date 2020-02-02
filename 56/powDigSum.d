#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.typecons;
import kreikey.bigint;
import kreikey.intmath;

void main() {
  StopWatch timer;
  
  timer.start();

  auto maxDigSum = iota(2, 101)
    .map!(a => iota(2, 101)
        .map!(b => (BigInt(a) ^^ b).toDigits.sum())
        .array())
    .join
    .fold!max();

  timer.stop();

  writefln("Max digit sum: %s", maxDigSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
