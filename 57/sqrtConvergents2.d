#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;
import std.math;
import std.concurrency;
import std.traits;
import std.conv;
import kreikey.bigint;
import kreikey.intmath;

void main() {
  StopWatch timer;

  writeln("Square root convergents");

  timer.start();
  auto sqrt2seq = squareRootSequence(2);
  auto approximations = ContinuedFraction!(int[], BigInt)(sqrt2seq);
  auto count = approximations
    .take(1000)
    .count!(a => a[0].digitsLength > a[1].digitsLength)();
  timer.stop();

  writeln("The number of fractions containing a numerator with more digits than the denominator is:");
  writeln(count);
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
