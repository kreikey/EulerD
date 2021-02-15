#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import std.traits;
import kreikey.intmath;
import kreikey.bigint;

void main() {
  StopWatch timer;
  timer.start();
  writeln("Odd period square roots");

  auto oddPeriods = iota(2, 10001)
    .map!squareRootSequence
    .count!(a => (a.length - 1) % 2 == 1)();

  writeln("The number of odd period square roots <= 10,000 is:");
  writeln(oddPeriods);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

/*
auto squareRootSequence(T)(T number)
if (isIntegral!T || is(T == BigInt)) {
  T a0 = cast(T)sqrt(cast(real)number);
  T[] result;
  T a;
  T b = a0;
  T d = 1;
  T n = 1;
  T t;

  result ~= a0;

  do {
    d = number - b^^2;
    if (d == 0)
      break;
    d /= n;
    t = a0 + b;
    a = t / d;
    result ~= a;
    n = d;
    b = a0 - (t % d);
  } while (d != 1);

  return result;
}
*/
