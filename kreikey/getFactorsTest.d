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

  for (int n = 1; n < 1000001; n++) {
    //writeln(n);
    //memoize!(getPrimeFactors!(typeof(n)))(n).writeln();
    //memoize!(getPrimeFactorGroups!(typeof(n)))(n).writefln!"[%(%(%s:%s%), %)]"();
    //memoize!(getDistinctPrimeFactors!(typeof(n)))(n).writeln();
    //memoize!(getFactors!(typeof(n)))(n).writeln();
    //memoize!(getProperDivisors!(typeof(n)))(n).writeln();
    //writeln("factor count: ", memoize!(countFactors!(typeof(n)))(n));
    //getFactors(n);
    //memoize!(getPrimeFactors2!(typeof(n)))(n);
    memoize!(getFactors2!(typeof(n)))(n);

    if (n % 10000 == 0)
      writeln(n / 10000, "%");
  }

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
