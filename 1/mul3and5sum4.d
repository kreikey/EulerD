#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.functional;
import std.conv;

// partial used to be called curry. This alias is no longer necessary, as sum works.
//alias partial!(std.algorithm.reduce!((a, b) => a + b), 0UL) addn;

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1000;
  ulong result;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  timer.start();

  result = iota(3, limit, 3)
  .merge(iota(5, limit, 5))
  .uniq
  .sum();

  timer.stop();
  writeln("The sum multiples of 3 and 5 below ", limit, " is: ", result);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

