#!/usr/bin/env rdmd -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import kreikey.bigint;

void main(string[] args) {
  StopWatch sw;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  sw.start();

  iota(2, n + 1)
    .map!(a => iota(2, n + 1)
        .map!(b => BigInt(a) ^^ b)
        .array())
    .array
    .multiwayUnion
    .count
    .writeln();

  //writeln(count(multiwayUnion(array(map!(a => array(map!(b => BigInt(a) ^^ b)(iota(2, n + 1))))(iota(2, n + 1))))));

  sw.stop();

  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

