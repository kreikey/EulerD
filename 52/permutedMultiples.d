#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import kreikey.combinatorics;
import kreikey.intmath;

alias isPermutation = kreikey.combinatorics.isPermutation;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Permuted multiples");

  auto result = InfiniteIota(1uL)
    .map!(a => iota(2uL, 7)
        .map!(b => toDigits(a * b)))
    .find!(a => a
        .slide(2)
        .all!(b => isPermutation(b[0], b[1])))
    .front[0]
    .toNumber() / 2;

  timer.stop();

  writeln("The smallest positive integer whose multiples from 2 through 6 contain the same digits is:");
  writeln(result);
  writefln!"Finished in %s milliseconds."(timer.peek.total!"msecs"());
}
