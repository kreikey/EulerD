#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.algorithm;
import std.datetime.stopwatch;
import kreikey.intmath;
import kreikey.util;
import std.functional;

void main() {
  StopWatch timer;

  timer.start();

  foreach (n; 1 .. 1000001) {
    //writeln(n);
    //memoize!(getPrimeFactors!uint)(n).writeln();
    //memoize!(getPrimeFactorGroups!uint)(n).writefln!"[%(%(%s:%s%), %)]"();
    //memoize!(getDistinctPrimeFactors!uint)(n).writeln();
    //memoize!(getFactors!uint)(n).writeln();
    //memoize!(getProperDivisors!uint)(n).writeln();
    //writeln("factor count: ", memoize!(countFactors!uint)(n));
    getFactors(n);

    if (n % 10000 == 0)
      writeln(n / 10000, "%");
  }

  timer.stop();

  writefln("finished in %s seconds", timer.peek.total!"seconds"());
}
