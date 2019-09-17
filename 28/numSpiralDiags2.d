#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

void main(string[] args) {
  ulong n = 1001;
  StopWatch timer;

  timer.start();

  if (args.length > 1)
    n = args[1].parse!ulong();

  recurrence!((a, n) => a[n-4] + 2)(1, 2, 2, 2, 2)
    .cumulativeFold!((a, b) => a + b)(0)
    .take((n - 1) * 2 + 1)
    .sum
    .writeln();

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}
