#!/usr/bin/env rdmd

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;
import std.array;
import std.range;

void main(string[] args) {
  StopWatch timer;
  int topNum = 100;
  int[] arr;

  if (args.length > 1)
    topNum = args[1].parse!(int);

  timer.start();
  arr = iota(1, topNum + 1).array();
  int sumsquares = reduce!((a, b) => a + b * b)(0, arr);
  int sum = reduce!((a, b) => a + b)(0, arr);
  int difference = sum * sum - sumsquares;
  timer.stop();

  writeln(difference);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
