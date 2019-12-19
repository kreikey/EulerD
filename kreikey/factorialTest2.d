#!/usr/bin/env rdmd -i -I..

import kreikey.intmath;
import std.stdio;
import std.datetime.stopwatch;

void main() {
  StopWatch timer;
  //factorial(29uL).writeln();
  ulong result = 0;

  timer.start();

  ulong x = 1000000;
  ulong y = 23;
  writeln(ulong.max);

  writefln("Calculating %s * %s factorials.", x, y);

  foreach (i; 0..x) {
    foreach (ulong n; 0..y) {
      result = factorial(n);
      //writeln(result);
    }
    //writeln(result);
  }
  writeln(result);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
