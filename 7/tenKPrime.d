#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import kreikey.primes;

void main(string[] args) {
  StopWatch sw;
  int topNum = 10001;
  auto p = new Primes!int();

  sw.start();
  if (args.length > 1)
    topNum = args[1].to!(int);

  foreach (i; 1 .. topNum) {
    p.popFront();
  }

  sw.stop();
  writeln(p.front);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
