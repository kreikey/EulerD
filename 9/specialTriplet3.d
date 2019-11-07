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
  ulong p = 1000;

  if (args.length > 1) {
    p = parse!ulong(args[1]);
  }

  timer.start();
  writeln("special pythagorean triplet");

  if (p % 2 != 0) {
    writeln("The perimeter must be even!");
    return;
  }

  auto triplets = getTriplets(p);

  if (triplets.length > 0) {
    ulong tripletProduct = only(triplets[0].expand).fold!((a, b) => a * b)();
    writefln("%s^2 + %s^2 = %s^2", triplets[0].expand);
    writefln("%s * %s * %s = %s", triplets[0].expand, tripletProduct);
  } else {
    writeln("no pythagorean triplet found");
  }

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

