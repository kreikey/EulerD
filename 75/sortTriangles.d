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

void main(string[] args) {
  StopWatch timer;
  File inFile;

  if (args.length > 1) {
    try {
      inFile = File(args[1]);
    } catch (Exception e) {
      writeln("Something went wrong. Exiting.");
      writeln(e.msg);
      return;
    }
  } else {
    writeln("No file name given. Exiting");
    return;
  }

  timer.start();

  auto triangles = inFile
    .byLine()
    .map!(a => a.split(" ").map!(to!int))
    .map!(a => a[0], a => a[1], a => a[2], a => a[3])
    .array();

  triangles.sort!((a, b) => a[0] < b[0])();
  triangles.each!(a => a.writefln!("%(%s %s %s %s%)")())();

  timer.stop();
}
