#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.traits;
import std.typecons;
import std.math;
import std.conv;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;
  int maxLength = 1500000;
  int a = 1;
  int b = 0;
  ulong count = 0;
  long sum = 0;
  long[] perimeters = [];
  Tuple!(int, int, int, int)[] triangles;

  timer.start();
  writeln("Single integer right triangles");
  writeln("Please wait about half an hour.");

  auto squares = iota(0L, maxLength / 2)
    .map!(a => a^^2)
    .array();

  for (int c = 3; c < squares.length; c++) {
    b = c - 1;
    a = 1;

    while (a <= b) {
      sum = squares[a] + squares[b];
      if (sum == squares[c]) {
        triangles ~= tuple(a, b, c, a + b + c);
        a++;
        b--;
      } else if (sum < squares[c]) {
        a++;
        if (a + b + c > maxLength)
          b--;
      } else if (sum > squares[c]) {
        b--;
      }
    }
  }

  triangles.sort!((a, b) => a[3] < b[3])();
  triangles
    .group!((a, b) => a[3] == b[3])
    .filter!(a => a[1] == 1)
    .count
    .writeln();

  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
