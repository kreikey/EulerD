#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.functional;
import std.conv;

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1000;
  ulong result;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  timer.start();

  result = iota(1, limit).filter!(a => a % 3 == 0 || a % 5 == 0)
    .sum();

  timer.stop();
  writeln("The sum multiples of 3 and 5 below ", limit, " is: ", result);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

