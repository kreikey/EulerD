#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
//import std.range;
import std.algorithm;
import kreikey.primes;

void main(string[] args) {
  StopWatch sw;
  int limit = 10001;
  auto p = new Primes!int();

  sw.start();
  if (args.length > 1)
    limit = args[1].to!(int);

  p[limit - 1].writeln();
  //p.drop(limit - 1).front.writeln();

  sw.stop();

  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}