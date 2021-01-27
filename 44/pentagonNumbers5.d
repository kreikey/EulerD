#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import kreikey.figurates;

//from kreikey.figurates:
//alias Pentagonals = FigGen!(Figurates.pentagonal);

void main() {
  StopWatch timer;
  auto pentagonals = Pentagonals(1);
  ulong sum = 0;
  ulong pj = 0;
  ulong pk = 0;
  ulong difference = 0;
  ulong sumIndex = 2;
  ulong minIndex = 0;
  ulong bigIndex = sumIndex - 1;
  ulong littleIndex = minIndex;

  timer.start();
  writeln("Pentagon Numbers");

  for (;;) {
    sum = pentagonals[littleIndex] + pentagonals[bigIndex];
    if (sum == pentagonals[sumIndex]) {
      difference = pentagonals[bigIndex] - pentagonals[littleIndex];
      if (difference.isPentagonal()) {
        pj = pentagonals[littleIndex];
        pk = pentagonals[bigIndex];
        break;
      }
      littleIndex++;
      bigIndex--;
    } else if (sum > pentagonals[sumIndex]) {
      bigIndex--;
    } else if (sum < pentagonals[sumIndex]) {
      littleIndex++;
    }
    if (bigIndex <= littleIndex) {
      sumIndex++;
      bigIndex = sumIndex - 1;
      if (pentagonals[bigIndex] + pentagonals[minIndex] < pentagonals[sumIndex]) {
        minIndex++;
      }
      littleIndex = minIndex;
    }
  }

  writefln("The pentagonal numbers found are p: %s and k: %s", pj, pk);
  writefln("The pentagonal sum and difference are sum: %s and difference: %s", sum, difference);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs");
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
