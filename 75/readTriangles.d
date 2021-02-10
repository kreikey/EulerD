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
  //StopWatch timer;
  int a, b, c, p;
  //Tuple!(int, int, int, int)[] triangles;

  //timer.start();

  //foreach (l; File("numbers8.txt").byLine()) {
    //l.formattedRead!"%d %d %d %d"(a, b, c, p);
    //triangles ~= tuple(a, b, c, p);
  //}
  auto triangles = File("numbers9.txt")
    .byLine()
    .map!(a => a.split(" ").map!(to!int))
    .map!(a => a[0], a => a[1], a => a[2], a => a[3])
    .array();

  triangles.sort!((a, b) => a[3] < b[3])();

  auto groups = triangles
    .group!((a, b) => a[3] == b[3])
    .each!(a => writefln("%(%(%s %s %s %s%) %s%)", a))();

  //groups.sort();
  //groups.each!(a => writefln("%(%(%s %s %s %s%) %s%)", a))();

  //timer.stop();
  //writefln("finished in %s milliseconds.", timer.peek.total!"msecs"());
}
