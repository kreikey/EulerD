#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.traits;
import std.typecons;
import std.math;
import std.conv;
import std.format;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;
  int a, b, c, p;
  Tuple!(int, int, int, int)[] triangles;

  timer.start();

  foreach (l; File("triangles3.txt").byLine()) {
    l.formattedRead!"%d^2 + %d^2 = %d^2 p = %s"(a, b, c, p);
    triangles ~= tuple(a, b, c, p);
  }
  
  triangles.sort!((a, b) => a[3] < b[3])();
  auto count = triangles
    .group!((a, b) => a[3] == b[3])
    .filter!(a => a[1] == 1)
    .count();

  writeln(count);

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek.total!"msecs"());
}
