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

  writeln("Please wait for about a minute...");
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
  auto pentagonals = Pentagonals().dropOne();
  auto diffDiffGen = recurrence!((a, n) => (n - 2)%3==0 ? 0 : a[n-1]+1)(0, 0, 0, 2, 2);
  auto diffGen = diffDiffGen.cumulativeFold!((a, b) => a + b)(0);
  auto distGen = diffGen.cumulativeFold!((a,b) => a + b)(1);
  long pj = 0;
  long pk = 0;


  foreach (i, d; distGen.enumerate()) {
    foreach (j; iota(i+1, i+d+1)) {
      pj = pentagonals[i];
      pk = pentagonals[j];
      if (isPentagonal(pj + pk) && isPentagonal(pk - pj)) {
        writeln("Pentagonal sum and difference found!");
        return tuple(pj, pk);
      }
    }
    if (i == short.max)
      break;
  }
  return tuple(-1L, -1L);
}
