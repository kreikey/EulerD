#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;

alias PentagonalGenerator = (a, n) => n * (3 * n - 1) / 2;
alias Pentagonals = ReturnType!(sequence!(PentagonalGenerator));
ReturnType!isPentagonalInit isPentagonal;

static this() {
  isPentagonal = isPentagonalInit();
}

void main() {
  StopWatch timer;
  timer.start();
  writeln("Pentagon Numbers");
  long pj = 0;
  long pk = 0;

  writeln("Please wait for a few seconds...");
  auto found = findSpecialPentagonals();

  pj = found[0];
  pk = found[1];

  writefln("The pentagonal numbers found are p: %s and k: %s", pj, pk);
  writefln("The pentagonal sum and difference are sum: %s and difference: %s", pj + pk, pk - pj);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

auto isPentagonalInit() {
  auto temp = Pentagonals();
  bool[long] cache = null;

  return delegate(long number) {
    auto pentagonals = refRange(&temp);
    if (pentagonals.front <= number)
      pentagonals.until!(a => a > number)
        .each!(a => cache[a] = true);
        
    return number in cache ? true : false;
  };
}

Tuple!(long, long) findSpecialPentagonals() {
  auto pentagonals = sequence!PentagonalGenerator().dropOne();
  long sum;
  ulong j=0;

  for (ulong i = 0; i < short.max; i++) {
    j = i+1;
    do  {
      sum = pentagonals[i] + pentagonals[j];
      if (isPentagonal(sum) && isPentagonal(pentagonals[j] - pentagonals[i])) {
        writeln("Pentagonal sum and difference found!");
        return tuple!(long, long)(pentagonals[i], pentagonals[j]);
      }
      j++;
    } while (sum >= pentagonals[j+1]);
  }
  return tuple(-1L, -1L);
}