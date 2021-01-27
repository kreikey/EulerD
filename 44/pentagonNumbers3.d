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

  auto pentagonals = Pentagonals(1);

  auto diffDiffGen = recurrence!((a, n) => (n - 2)%3==0 ? 0 : a[n-1]+1)(0, 0, 0, 2, 2);
  auto diffGen = diffDiffGen.cumulativeFold!((a, b) => a + b)(0);
  auto distGen = diffGen.cumulativeFold!((a,b) => a + b)(1);
  auto found = distGen.enumerate
    .map!(a => iota(a[0]+1, a[0]+a[1]+1)
        .map!(b => pentagonals[a[0]], b => pentagonals[b]))
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
*/
