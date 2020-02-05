#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;
import kreikey.bigint;

void main() {
  StopWatch timer;

  writeln("Square root convergents");

  timer.start();
  auto count = sqrtOfTwoFracsInit
    .generate
    .take(1000)
    .count!(a => a[0].digitsLength > a[1].digitsLength)();
  timer.stop();

  writeln("The number of fractions containing a numerator with more digits than the denominator is:");
  writeln(count);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto sqrtOfTwoFracsInit() {
  auto result = tuple(BigInt(1), BigInt(1));
  auto sqrtOfTwoFracs() {
    result[0] += result[1];
    result[1] += result[0];
    swap(result[0], result[1]);
    return result;
  }
  return &sqrtOfTwoFracs;
}
