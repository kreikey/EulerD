#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import kreikey.primes;

void main(string[] args) {
  StopWatch timer;
  ulong topNum = 10001;
  auto p = new Primes!ulong();

  timer.start();
  if (args.length > 1)
    topNum = args[1].to!(ulong);

  foreach (i; 1 .. topNum) {
    p.popFront();
  }

  timer.stop();
  writeln(p.front);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
