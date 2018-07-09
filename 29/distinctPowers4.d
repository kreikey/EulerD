#!/usr/bin/env rdmd -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.functional;
import kreikey.intmath;
import kreikey.bigint;

alias primeFactorsFast = memoize!primeFactors;
//alias lessThan = (a, b) => cmp(a, b) < 0;
alias sort = a => std.algorithm.sort(a).array();

void main(string[] args) {
  StopWatch clock;
  ulong n = 5;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  clock.start();

  iota(2, n+ 1)
    .map!(base => iota(2, n+1)
      .map!(exponent => base.primeFactorsFast.cycleN(exponent).sort())
      .array
      .sort())
    .array
    .multiwayUnion
    .count
    .writeln();

  // Imperative style. For the record.
/*
 *  ulong[][][] powersMatrix;
 *  ulong[][] row;
 *  ulong[] res;
 *
 *  foreach(base; 2 .. n + 1) {
 *    row = [];
 *    foreach(exponent; 2 .. n + 1) {
 *      res = base.primeFactors.cycleN(exponent).sort.array();
 *      row ~= res;
 *    }
 *    sort(row);
 *    powersMatrix ~= row;
 *  }
 *
 *  powersMatrix.multiwayMerge.uniq.count.writeln();
 */

  clock.stop();

  writefln("finished in %s milliseconds", clock.peek.total!"msecs"());
}

auto cycleN(ulong[] array, ulong copies) {
  return array.cycle.take(array.length * copies).array();
}
