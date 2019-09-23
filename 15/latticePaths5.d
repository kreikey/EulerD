#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;
import std.algorithm;
import std.range;

struct NK {
  ulong n;
  ulong k;
}

void main(string[] args) {
  ulong width = 20, height = 20, pathCount;
  StopWatch timer;

  if (args.length > 2) {
    width = args[1].parse!ulong();
    height = args[2].parse!ulong();
  }

  timer.start();
  pathCount = nChooseK((width + height), height);
  timer.stop();
  writefln("The number of lattice paths in a %sx%s grid from top left parse bottom right are:\n%s",
      width, height, pathCount);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong nChooseK(ulong n, ulong k) {
  assert(k <= n);
  ulong sum = 0;

  int[] list = 0.repeat(n - k).chain(1.repeat(k)).array();

  do {
    sum++;
  } while (list.nextPermutation() != false);

  return sum;
}
