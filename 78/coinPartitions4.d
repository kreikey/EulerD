#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;
import kreikey.util;

void main() {
  StopWatch timer;
  
  writeln("Coin partitions");
  timer.start();

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");

  recurrence!((a, n) => a[n-1]+1, uint)(1)
    .map!(a => memoize!countPartitions(a, 6))
    .until(0, OpenRight.no)
    .count
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countPartitions(int num, int digitsToKeep) {
  ulong count = 0;
  ulong digitsMod = 10 ^^ digitsToKeep;

  if (num == 0 || num == 1)
    return ulong(1);

  only(1)
    .chain(recurrence!((a, n) => a[n-1]+1, int)(1)
        .roundRobin(recurrence!((a, n) => a[n-1]+2, int)(3)))
    .cumulativeFold!((a, b) => a + b)
    .map!(a => num - a)
    .until!(a => a < 0)
    .map!(a => memoize!countPartitions(a, digitsToKeep))
    .enumerate(2)
    .each!(a => count = (count + digitsMod + ((a[0] / 2) % 2 == 1 ? a[1] : -a[1])) % digitsMod);

  return count;
}
