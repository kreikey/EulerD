#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.typecons;
import std.functional;

alias collatzChainLength = memoize!collatzChainLengthImpl;

void main(string[] args) {
  ulong top = 1000000;
  ulong maxStart;
  ulong maxChainLength;
  StopWatch timer;

  timer.start();

  if (args.length > 1)
    top = args[1].parse!ulong();

  auto result = iota(1, top)
    .map!(collatzChainLength, a => a)
    .reduce!((a, b) => max(a, b))();

  maxStart = result[1];
  maxChainLength = result[0];

  timer.stop();
  writefln("The number under %s producing the longest chain is %s", top, maxStart);
  writefln("It produces a chain of length %s", maxChainLength);
  writefln("Finished in %d milliseconds", timer.peek.total!"msecs"());
}

ulong nextCollatz(ulong n) {
  return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

ulong collatzChainLengthImpl(ulong n) {
  if (n == 1)
    return 1;

  return nextCollatz(n).collatzChainLength() + 1;
}

