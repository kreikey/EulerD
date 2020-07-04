#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.functional;
import kreikey.intmath;
import kreikey.bigint;

alias asort = (a) {a.sort(); return a;};

void main(string[] args) {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  timer.start();

  ulong[][][] powersMatrix;
  ulong[][] row;
  ulong[] res;

  foreach(base; 2 .. n + 1) {
    row = [];
    foreach(exponent; 2 .. n + 1) {
      res = base.primeFactors.cycleN(exponent).sort.array();
      row ~= res;
    }
    sort(row);
    powersMatrix ~= row;
  }

  powersMatrix.multiwayMerge.uniq.count.writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong[] cycleN(ulong[] array, ulong copies) {
  return array.cycle.take(array.length * copies).array();
}

