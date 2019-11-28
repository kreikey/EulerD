#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong pmax = 1000;
  ulong p = 0;
  ulong pmost = 0;
  alias Triplet = Tuple!(ulong, ulong, ulong);
  Triplet[] triplets = [];

  if (args.length > 1) {
    pmax = parse!ulong(args[1]);
  }

  timer.start();
  writeln("integer right triangles");

  auto result = iota!ulong(4, pmax + 1, 2)
    .map!(a => a, getTriplets)
    .map!(a => a[1].length, a => a[0], a => a[1])
    .fold!max();

  triplets = result[2];
  pmost = result[1];

  writefln("For all perimeters P <= %s, P = %s yields the most integer right triangles.", pmax, pmost);
  writeln("Its triangles are: ");
  triplets.each!(a => writefln("%(A: %s\tB: %s\tC: %s%)", a))();

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

