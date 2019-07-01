#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import kreikey.intmath;

void main(string[] args) {
  StopWatch sw;
  sw.start();

  ulong mul = 2;

  foreach (i; 3..21)
    mul = mul.lcm(i);

  sw.stop();

  writeln(mul);
  writeln("finshed in ", sw.peek.total!"msecs"(), " milliseconds");
}

