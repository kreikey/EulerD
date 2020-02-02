#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;
//import kreikey.bigint;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  timer.start();

  iota(2, n + 1)
    .map!classifyPerfectPower
    .map!(a => iota(2, n + 1)
        .map!(b => tuple(a[0], a[1] * b))
        .array())
    .array
    .multiwayUnion
    .count
    .writeln();

  //writeln(count(multiwayUnion(array(map!(a => array(map!(b => tuple(a[0], a[1] * b))(iota(2, n + 1))))(map!classifyPerfectPower(iota(2, n + 1)))))));

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

