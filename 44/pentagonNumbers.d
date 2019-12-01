#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.traits;
import std.parallelism;
import std.typecons;

alias PentagonalGenerator = (a, n) => (n+1)*(3*(n+1)-1)/2;
alias Pentagonals = ReturnType!(sequence!(PentagonalGenerator, ulong));
ReturnType!isPentagonalInit isPentagonal;

static this() {
  isPentagonal = isPentagonalInit();
}

void main() {
  StopWatch timer;
  timer.start();
  writeln("Pentagon Numbers");
  Pentagonals pentagonals = sequence!PentagonalGenerator(0uL);
  auto diffDiffGen = recurrence!((a, n) => (n - 2)%3==0 ? 0 : a[n-1]+1)(0, 0, 0, 2, 2);
  auto diffGen = diffDiffGen.cumulativeFold!((a, b) => a + b)(0);
  auto distGen = diffGen.cumulativeFold!((a,b) => a + b)(1);
  long pj = 0;
  long pk = 0;

  writeln("Please wait for about a minute...");
  auto found = distGen.enumerate
    //.tee!(a => writeln(pentagonals[a[0]]))
    .map!(a => iota(a[0]+1, a[0]+a[1]+1)
        .map!(b => pentagonals[a[0]], b => pentagonals[b])
        )
    .joiner
    .find!(a => isPentagonal(a[1] - a[0]) && isPentagonal(a[0] + a[1]))
    .front;

  //auto found = findSpecialPentagonals();

  pj = found[0];
  pk = found[1];

  writefln("The pentagonal numbers found are p: %s and k: %s", pj, pk);
  writefln("The pentagonal sum and difference are sum: %s and difference: %s", pj + pk, pk - pj);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

auto isPentagonalInit() {
  auto pentagonals = new Pentagonals();
  bool[long] cache = null;

  bool isPentagonal(long number) {
    if (pentagonals.front <= number)
      pentagonals
        .tee!(a => cache[a] = true)
        .find!(a => a > number)();

    return number in cache ? true : false;
  }

  return &isPentagonal;
}

Tuple!(long, long) findSpecialPentagonals() {
  auto pentagonals = Pentagonals();
  auto diffDiffGen = recurrence!((a, n) => (n - 2)%3==0 ? 0 : a[n-1]+1)(0, 0, 0, 2, 2);
  auto diffGen = diffDiffGen.cumulativeFold!((a, b) => a + b)(0);
  auto distGen = diffGen.cumulativeFold!((a,b) => a + b)(1);
  long pj = 0;
  long pk = 0;


  foreach (i, d; distGen.enumerate()) {
    //writeln(i, "\t", pentagonals[i]);
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
