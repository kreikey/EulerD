#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;
import kreikey.figurates;

//from kreikey.figurates:
//alias Pentagonals = FigGen!(Figurates.pentagonal);

void main() {
  StopWatch timer;
  long pj = 0;
  long pk = 0;

  timer.start();
  writeln("Pentagon Numbers");
  writeln("Please wait for about a minute...");
  auto found = findSpecialPentagonals();

  pj = found[0];
  pk = found[1];

  writefln("The pentagonal numbers found are p: %s and k: %s", pj, pk);
  writefln("The pentagonal sum and difference are sum: %s and difference: %s", pj + pk, pk - pj);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

Tuple!(long, long) findSpecialPentagonals() {
  auto pentagonals = Pentagonals(1);
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

/*
auto isFigurateInit(alias generator)() {
  auto temp = generator();
  bool[ulong] cache = null;

  return delegate(ulong num) {
    auto figurates = refRange(&temp);
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  };
}
*/
