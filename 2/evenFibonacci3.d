#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import std.conv;
import std.range;

void main(string[] args) {
  StopWatch sw;
  ulong limit = 4000000;
  ulong result;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  sw.start();

  result = recurrence!((a, n) => a[1] + a[0])(1, 1).until!(a => a >= limit).filter!(a => a % 2 == 0).sum();

  sw.stop();
  writeln("The sum of even fibonacci numbers not greater than ", limit, " is:\n", result);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds.");
}
