#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.typecons;
//import kreikey.intmath;
import kreikey.primes;

bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  
  writeln("Spiral primes");

  timer.start();

  auto count = recurrence!((a, n) => a[n-4] + 2)(1, 2, 2, 2, 2)
    .cumulativeFold!((a, b) => a + b)
    .cumulativeFold!((a, b) => a + 1, (a, b) => a + (b.isPrime() ? 1 : 0))(tuple(0, 0))
    .until!(a => a[1] > 0 && float(a[1])/a[0] < 0.1)
    .tail(1)
    .front[0];

  auto width = widthByDiagonalCount(count);

  timer.stop();

  writeln("The width of the spiral where the primes/diagonals ratio falls below 10% is:");
  writeln(width);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong widthByDiagonalCount(ulong count) {
  auto width = count;
  width--;
  auto rem = width % 2;
  width /= 2;
  width += 1 + rem;
  width += (width % 2 ? 0 : 1);
  return width;
}
