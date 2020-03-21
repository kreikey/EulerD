#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import kreikey.intmath;

void main() {
  StopWatch timer;
  timer.start();
  writeln("Odd period square roots");

  auto oddPeriods = iota(2, 10001uL)
    .map!squareRootSequence
    .count!(a => a[1].length % 2 == 1)();

  writeln("The number of odd period square roots <= 10,000 is:");
  writeln(oddPeriods);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

Tuple!(long, long[]) squareRootSequence(long number) {
  Tuple!(long, long[]) result;
  long a0 = sqrt(float(number)).lrint();
  long a;
  long b;
  long d = 1;
  long n = 1;
  long t;

  b = a0;

  do {
    d = number - b^^2;
    if (d == 0)
      break;
    d /= n;
    t = a0 + b;
    a = t / d;
    result[1] ~= a;
    n = d;
    b = a0 - (t % d);
  } while (d != 1);

  return result;
}
