#!/usr/bin/env rdmd

import std.stdio;
import std.datetime.stopwatch;
import std.traits;

void main() {
  StopWatch timer;
  ulong sum;

  timer.start();
  foreach (i; 1 .. 1000) {
    if (i % 3 == 0 || i % 5 == 0) {
      sum += i;
    }
  }
  timer.stop();

  writeln(sum);
  writeln("finished in ", timer.peek.total!"msecs", " milliseconds");
}
