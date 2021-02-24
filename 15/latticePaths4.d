#!/usr/bin/env rdmd -I.. -i
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;
import std.string;
import std.typecons;
import kreikey.combinatorics;
import std.experimental.checkedint;
import kreikey.bigint;

void main(string[] args) {
  ulong width = 20L, height = 20L, pathCount;
  StopWatch timer;

  if (args.length > 2) {
    width = args[1].parse!ulong();
    height = args[2].parse!ulong();
  }

  timer.start();

  try {
    pathCount = nChooseK((width + height), height);
    timer.stop();
    writefln("The number of lattice paths in a %sx%s grid from top left to bottom right is:\n%s",
      width, height, pathCount);
    writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
  } catch (Exception e) {
    writeln("Overflow! Those input numbers are too big to yield an accurate result.");
  }
}

