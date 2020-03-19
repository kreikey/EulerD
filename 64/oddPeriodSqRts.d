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
    .map!(a => a[1].length)
    .filter!(a => a % 2 == 1)
    .count();

  writeln("The number of odd period square roots <= 10,000 is:");
  writeln(oddPeriods);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

void squareRoots(int number) {
  writefln("%.62s", sqrt(real(number)));
  writeln(sqrtInt(number));
}

ulong sqrtInt(ulong number) {
  ulong start = 1;
  ulong end = number;
  ulong delta;
  ulong halfDelta;
  ulong candidate;
  ulong candidateSq;

  if (number == 0)
    return 0;

  do {
    delta = end - start;
    halfDelta = delta / 2;
    candidate = start + halfDelta;
    candidateSq = candidate ^^ 2;
    if (candidateSq > number) {
      end = candidate;
    } else {
      start = candidate;
    }
  } while (delta > 1);

  return candidate;
}

/*
   root(13)
   3 + root(13) - 3
   3 + 1 / (1 / (root(13) - 3))
   3 + 1/(root(13) + 3) / 4)
   3 + 1/(1 + (root(13) - 1) / 4)
   3;(1, )


*/


Tuple!(long, long[]) squareRootSequence(long number) {
  Tuple!(long, long[]) result;
  long a = sqrtInt(number);
  long offset;
  long denom = 1;
  long num = 1;
  long offsetNext;
  long factor = 0;
  Tuple!(long, long) fraction = tuple(1, 1);

  result[0] = a;
  offset = -a;

  do {
    denom = number + offset * -offset;
    if (denom == 0)
      break;
    fraction = reduceFrac(num, denom);
    num = fraction[0];
    denom = fraction[1];
    offsetNext = -offset;

    do {
      offsetNext -= denom;
      factor++;
    } while (!(offsetNext < -result[0]));

    offsetNext += denom;
    factor--;
    offset = offsetNext;
    num = denom;
    a = factor;
    factor = 0;
    result[1] ~= a;
  } while (denom != 1);

  return result;
}
