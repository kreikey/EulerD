#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.algorithm;
import std.datetime.stopwatch;
import kreikey.intmath;
import kreikey.util;

void main() {
  StopWatch timer;

  timer.start();

  foreach (n; 1u .. 1000001u) {
    auto factors2 = getAllFactors2(n);
    //auto factors = getAllFactors(n);
    //writeln(factors);
    //writeln(factors2);
    //sort(factors2);
    //assert(factors == factors2);

    if (n % 10000 == 0)
      writeln(n / 10000, "%");
  }

  timer.stop();

  writefln("finished in %s seconds", timer.peek.total!"seconds"());
}
