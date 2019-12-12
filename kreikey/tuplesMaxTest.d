#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.math;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;
import std.random;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Tuples Max Test");

  auto a = generate!(() => uniform(0, 100))();
  auto b = generate!(() => uniform(0, 100))();
  auto c = generate!(() => uniform(0, 100))();

  zip(a, b, c)
    .take(10)
    .tee!(a => a.writefln!"%(%s\t%s\t%s%)"())
    .fold!max
    .writefln!"\nmax: %(%s\t%s\t%s%)"();

  //auto a = tuple(
  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

