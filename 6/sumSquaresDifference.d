#!/usr/bin/env rdmd

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;
import std.array;
import std.range;

void main(string[] args) {
  StopWatch timer;
  ulong topNum = 100;
  ulong[] arr;

  if (args.length > 1)
    topNum = args[1].parse!(ulong);

  timer.start();
  arr = iota!ulong(1, topNum + 1).array();
  ulong sumsquares = arr.map!(a => a ^^ 2).sum();
  ulong sum = arr.sum();
  ulong difference = sum * sum - sumsquares;
  timer.stop();

  writeln(difference);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
