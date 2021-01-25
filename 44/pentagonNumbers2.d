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

Tuple!(long, long) findSpecialPentagonals() {
  auto pentagonals = Pentagonals(1);
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
