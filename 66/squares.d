#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.math;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;

void main() {
  auto squares = setDifference(
      InfiniteIota(1),
      InfiniteIota(1).map!(a => a^^2)())
    .until!(a => a > 1000)();
  squares.count().writeln();
}
