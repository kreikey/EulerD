#!/usr/bin/env rdmd

import std.stdio;
//import std.datetime;
import std.datetime.stopwatch;
import std.traits;

void main() {
  StopWatch sw;
  int sum;

  sw.start();
  foreach (i; 1 .. 1000) {
    if (i % 3 == 0 || i % 5 == 0) {
      sum += i;
      //writeln(i);
    }
  }
  sw.stop();

  writeln(sum);
  writeln("finished in ", sw.peek.total!"msecs", " milliseconds");
}
