#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import std.conv;
import unionmultiples;

void main(string[] args) {
  StopWatch timer;
  auto um = new UnionMultiples(3, 5);
  ulong limit = 1000;
  ulong result;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  timer.start();

  result = um.until!((a, b) => a >= b)(limit).sum();

  timer.stop();
  writeln("The sum multiples of 3 and 5 below ", limit, " is: ", result);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}
