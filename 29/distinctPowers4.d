#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.array;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.functional;
import kreikey.intmath;
import kreikey.bigint;

alias primeFactors = memoize!(primeFactors2!ulong);
alias asort = (a) {a.sort(); return a;};

void main(string[] args) {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  timer.start();

  iota(2, n+ 1)
    .map!(base => iota(2, n+1)
      .map!(exponent => base.primeFactors.replicate(exponent).asort())
      .array
      .asort())
    .array()
    .multiwayUnion
    .count
    .writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

