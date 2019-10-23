#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

void main(string[] args) {
  ulong width = 1001;
  StopWatch timer;

  timer.start();

  if (args.length > 1)
    width = args[1].parse!ulong();

  spiralDiagonalsInit.generate.take(width.countDiagonals()).sum.writeln();

  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

auto spiralDiagonalsInit() {
  ulong i = 0;
  ulong n = 1;
  ulong stride = 2;

  ulong spiralDiagonals() {
    ulong lastn = n;
    if (i > 3) {
      stride += 2;
      i = 0;
    }
    i++;
    n += stride;
    return lastn;
  }

  return &spiralDiagonals;
}

ulong countDiagonals(ulong width) {
  if (width % 2 == 0)
    throw new Exception("countDiagonals() needs an odd number as an argument");
  return (width - 1) * 2 + 1;
}
