#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;

void main() {
  StopWatch timer;
  auto countPrimeSummations = countPrimeSummationsInit();
  
  timer.start();

  countPrimeSummations(10)
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto countPrimeSummationsInit() {
auto primes = makePrimes!uint();
ulong countPrimeSummations(uint sum) {
  ulong count = 0;

  void inner(uint piece, uint runningSum) {
    if (runningSum >= sum) {
      if (runningSum == sum)
        count++;
      return;
    }

    for (uint n = piece; n > 0; n--) {
      inner(n, runningSum + n);
    }
  }

  inner(sum - 1, 0);

  return count;
}
return &countPrimeSummations;
}
