#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
//import std.range;
import std.algorithm;
import kreikey.primes;

void main(string[] args) {
  StopWatch timer;
  ulong limit = 10001;
  auto p = new Primes!ulong();

  timer.start();
  if (args.length > 1)
    limit = args[1].to!(ulong);

  p[limit - 1].writeln();
  //p.drop(limit - 1).front.writeln();

  timer.stop();

  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
