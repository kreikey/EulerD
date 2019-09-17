#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.functional;
import kreikey.intmath;
import kreikey.bigint;

alias primeFactorsFast = memoize!(primeFactors!ulong);
alias asort = a => std.algorithm.sort(a).array();

void main(string[] args) {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  timer.start();

  iota(2, n+ 1)
    .map!(base => iota(2, n+1)
      .map!(exponent => base.primeFactorsFast.cycleN(exponent).asort())
      .array
      .asort())
    .array()
    .multiwayUnion
    .count
    .writeln();

  // Imperative style. For the record.
  //ulong[][][] powersMatrix;
  //ulong[][] row;
  //ulong[] res;

  //foreach(base; 2 .. n + 1) {
    //row = [];
    //foreach(exponent; 2 .. n + 1) {
      //res = base.primeFactors.cycleN(exponent).sort.array();
      //row ~= res;
    //}
    //sort(row);
    //powersMatrix ~= row;
  //}

  //powersMatrix.each!writeln;
  //powersMatrix.multiwayMerge.uniq.count.writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong[] cycleN(ulong[] array, ulong copies) {
  return array.cycle.take(array.length * copies).array();
}

