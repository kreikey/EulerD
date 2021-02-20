#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.typecons;
import kreikey.intmath;

void main() {
  StopWatch timer;
  timer.start();
  foreach (x; 3..150001) {
    getPythagoreanTriples(x);
  }
  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
