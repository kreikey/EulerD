#!/usr/bin/env rdmd

import std.stdio;
//import std.datetime;
import std.datetime.stopwatch;
import std.traits;

void main() {
  StopWatch timer;
  int sum;

  timer.start();
  foreach (i; 1 .. 1000) {
    if (i % 3 == 0 || i % 5 == 0) {
      sum += i;
      //writeln(i);
    }
  }
  timer.stop();

  writeln(sum);
  writeln("finished in ", timer.peek.total!"msecs", " milliseconds");
}
