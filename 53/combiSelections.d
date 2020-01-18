#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.combinatorics;
import kreikey.bigint;
import std.functional;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Combinatorial Selections");

  auto total = iota(BigInt(1), 101)
    .map!(a => iota(BigInt(1), a + 1)
        .map!(b => memoize!(nChooseK!BigInt)(a, b)))
    .joiner
    .cache
    .filter!(a => a > 1000000)
    .count();

  timer.stop();

  writeln(total);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
