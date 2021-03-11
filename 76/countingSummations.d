#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main() {
  StopWatch timer;
  
  timer.start();

  countSummations(100)
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countSummations(uint sum) {
  ulong count = 0;

  void inner(uint piece, uint runningSum) {
    if (runningSum >= sum) {
      if (runningSum == sum)
        count++;
      return;
    }

    for (uint n = piece; n > 0; n--) {
      inner(n, runningSum + n);
    }
  }

  inner(sum - 1, 0);

  return count;
}
