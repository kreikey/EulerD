#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;

  timer.start();
  auto squares = InfiniteIota(2)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(2);
  auto noSquares = setDifference(numbers, squares);
  noSquares.take(100).writeln();
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
