#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;

void main() {
  StopWatch timer;
  
  writeln("Coin partitions");
  timer.start();

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");

  multiCountPartitionsInit(6)
    .generate
    .until(0, OpenRight.no)
    .count
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto multiCountPartitionsInit(uint digitsToKeep) {
  uint digitsMod = 10 ^^ digitsToKeep;
  uint[] ps = [1];
  uint[] ids = [0];
  auto byOnes = recurrence!((a, n) => a[n-1]+1, uint)(1);
  auto byTwos = recurrence!((a, n) => a[n-1]+2, uint)(3);
  auto appendIntervals = roundRobin(byOnes, byTwos);
  uint sameLengthCount = 0;

  uint countPartitions4() {
    uint count = 0;
    auto terms = indexed(ps, ids);

    for (auto i = 0, subtract = false; i < terms.length; i += 2, subtract = !subtract) {
      count = (count + digitsMod + (subtract ? -terms[i] : terms[i])) % digitsMod;
    }

    for (auto i = 1, subtract = false; i < terms.length; i += 2, subtract = !subtract) {
      count = (count + digitsMod + (subtract ? -terms[i] : terms[i])) % digitsMod;
    }

    ps ~= count;
    sameLengthCount++;
    ++ids[];

    if (sameLengthCount == appendIntervals.front) {
      ids ~= 0;
      sameLengthCount = 0;
      appendIntervals.popFront();
    }

    return count;
  }

  return &countPartitions4;
}
