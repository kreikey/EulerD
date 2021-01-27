#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;
import std.functional;
import std.format;
import kreikey.figurates;
import kreikey.util;

//from kreikey.figurates:
//alias Pentagonals = FigGen!(Figurates.pentagonal);

void main() {
  StopWatch timer;
  long pj = 0;
  long pk = 0;

  timer.start();
  writeln("Pentagon Numbers");
  writeln("Please wait for about a minute...");

  auto pentagonals = Pentagonals(1);

  auto found = InfiniteIota(1)
    .map!(a => InfiniteIota(a+1)
        .until!(b => pentagonals[a] + pentagonals[b] <= pentagonals[b+1])(OpenRight.no)
        .map!(b => pentagonals[a], b => pentagonals[b]))
    .joiner
    .find!(a => isPentagonal(a[1] - a[0]) && isPentagonal(a[0] + a[1]))
    .front;

  pj = found[0];
  pk = found[1];

  writefln("The pentagonal numbers found are p: %s and k: %s", pj, pk);
  writefln("The pentagonal sum and difference are sum: %s and difference: %s", pj + pk, pk - pj);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
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
