#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");
  timer.start();

  iota(2, n + 1)
    .map!(a => iota(2, n + 1)
        .map!(b => BigInt(a) ^^ b)
        .array())
    .array
    .multiwayMerge
    .array
    .slide(2, 1)
    .fold!((a, b) => b[0] == b[1] ? a : a + 1)(1)
    .writeln();

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
