#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.typecons;
import kreikey.intmath;
import kreikey.util;
import kreikey.bigint;

/*
   x^2 - Dy^2 = 1
   x^2 = 1 + Dy^2
   x = sqrt(1 + Dy^2)
   x^2-1 = Dy^2
   sqrt(x^2-1) = sqrt(D)y
   sqrt(x^2-1)/sqrt(D) = y
*/

void main() {
  StopWatch timer;

  timer.start();

  auto squares = InfiniteIota(1)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(1);
  auto noSquares = setDifference(numbers, squares);
  ulong Dmax = 0;
  BigInt xmax = 0;

  Tuple!(BigInt, BigInt) xy;
  ulong x, y;

  foreach (d; noSquares.until!(a => a > 1000)) {
    xy = diophantineMinX(d);
    if (xy[0] > xmax) {
      xmax = xy[0];
      Dmax = d;
    }
  }

  writefln("D with biggest min x: %s, biggest min x: %s", Dmax, xmax);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto diophantineMinX(ulong d) {
  auto estimates = d
    .squareRootSequence
    .continuedFraction!BigInt();

  foreach (x, y; estimates)
    if (x ^^ 2 - BigInt(d) * y ^^ 2 == 1)
      return tuple(x, y);

  return tuple(BigInt(0), BigInt(0));
}
