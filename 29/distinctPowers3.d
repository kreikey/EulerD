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

  //BigInt last = 0;
  bool delegate(BigInt) unique = notEqualToPreviousInit(BigInt(0));

  int count = 0;

  // Implemented the solution using more primitive constructs, because it's good to know how to use them.
  iota(2, n + 1)
    .map!(a => iota(2, n + 1)
        .map!(b => BigInt(a) ^^ b)
        .array())
    .array
    .multiwayMerge
    //.filter!(unique)
    //.fold!((int a, BigInt b) => a + 1)(0)
    .array
    .slide(2, 1)
    .fold!((a, b) => b[0] == b[1] ? a : a + 1)(1)
    .writeln();

  sw.stop();

  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

bool delegate(BigInt) notEqualToPreviousInit(BigInt previous) {
  bool notEqualToPrevious;

  bool nepfunc(BigInt current) {
    if (current != previous)
      notEqualToPrevious = true;
    else
      notEqualToPrevious = false;

    previous = current;

    return notEqualToPrevious;
  }

  return &nepfunc;
}
