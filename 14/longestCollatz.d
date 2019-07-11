#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;

void main(string[] args) {
  ulong top = 1000000;
  ulong maxStart;
  StopWatch sw;

  sw.start();

  if (args.length > 1)
    top = args[1].to!(ulong);

  maxStart = maxStartingNumberUnder(top);
  sw.stop();
  writefln("The number under %s producing the longest chain is %s", top, maxStart);
  writefln("Finished in %d milliseconds", sw.peek.total!"msecs"());
}

ulong nextCollatz(ulong n) {
  return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

ulong collatzChainLength(ulong n) {
  ulong count = 1;

  while (n > 1) {
    n = nextCollatz(n);
    count++;
  }

  return count;
}

ulong maxStartingNumberUnder(ulong top) {
  ulong maxChainLength;
  ulong curChainLength;
  ulong maxStart;

  foreach (ulong i; 1..top) {
    curChainLength = collatzChainLength(i);

    if (curChainLength > maxChainLength) {
      maxChainLength = curChainLength;
      maxStart = i;
    }
  }

  return maxStart;
}
