#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;
import kreikey.figurates;

void main() {
  StopWatch timer;
  timer.start();
  writeln("Triangular, pentagonal, and hexagonal numbers");

  auto triangulars = Triangulars(1);
  auto pentagonals = Pentagonals(1);
  auto hexagonals = Hexagonals(1);

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

