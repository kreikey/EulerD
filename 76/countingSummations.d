#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main() {
  StopWatch timer;
  
  writeln("Counting summations");

  timer.start();

  countSummations(100)
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countSummations(uint sum) {
  ulong count = 0;

  bool inner(uint piece, uint runningSum) {
    if (runningSum == sum) {
      count++;
      return true;
    }

    for (uint n = 1; n <= piece; n++) {
      if (inner(n, runningSum + n))
        break;
    }

    return false;
  }

  for (uint n = 1; n < sum; n++)
    inner(n, n);

  return count;
}
