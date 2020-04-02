#!/usr/bin/env rdmd -i -I..
import std.stdio;
import std.range;
import std.algorithm;
import std.math;
import std.datetime.stopwatch;
import kreikey.util;
import kreikey.intmath;

void main() {
  StopWatch timer;
  timer.start();
  auto piSixSq = 1 + InfiniteIota(2)
    .map!(a => a^^2)
    .map!(a => (1 / real(a)))
    .take(100000000)
    .sum();
  writeln(piSixSq);
  writefln("%.7f", sqrt(piSixSq * 6));
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
