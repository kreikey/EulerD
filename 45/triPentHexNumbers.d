#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;

void main() {
  StopWatch timer;
  timer.start();
  writeln("Triangular, pentagonal, and hexagonal numbers");

  auto triangulars = recurrence!((a, n) => a[n-1] + n + 1)(1);
  auto pentagonals = recurrence!((a, n) => a[n-1] + 3*n + 1)(1);
  auto hexagonals = recurrence!((a, n) => a[n-1] + 4*n + 1)(1);

  auto found = merge(triangulars, pentagonals, hexagonals)
    .group
    .filter!(a => a[1] == 3)
    .tee!(a => writefln("%(%s\t%s%)", a))
    .take(3)
    .tail(1)
    .front;

  timer.stop();
  writefln("The next triangle number after 40755 that is also pentagonal and hexagonal is:\n%s", found[0]);
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

