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
  
  writeln("Prime summations");

  timer.start();

  ulong m = 0;
  uint result = 0;
  for (uint n = 4;; n++) {
    m = countPrimeSummations(n);
    result = n;
    if (m > 5000)
      break;
  }

  writeln(result);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto countPrimeSummationsInit() {
  auto primes = makePrimes!uint();

  ulong countPrimeSummations(uint sum) {
    ulong count = 0;

    bool inner(uint piece, uint runningSum) {
      if (runningSum == sum) {
        count++;
        return true;
      } else if (runningSum > sum) {
        return true;
      }

      for (uint i = 0; primes[i] <= piece; i++) {
        if (inner(primes[i], runningSum + primes[i]))
          break;
      }

      return false;
    }

    inner(sum - 1, 0);
    return count;
  }

  return &countPrimeSummations;
}
