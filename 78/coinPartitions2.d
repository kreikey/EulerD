#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import std.functional;
import std.typecons;
import kreikey.intmath;
import kreikey.bigint;

void main() {
  StopWatch timer;
  int n = 0;
  BigInt x = 0;
  
  writeln("Coin partitions");
  writeln("Please wait for about a minute...");
  timer.start();

  do {
    n++;
    x = memoize!countPartitions(n);
    //writeln(n, " : ", x.digitString.tail(10));
  } while (!(x.length > 6 && x.digitString()[$-6 .. $] == "000000"));

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");
  writeln(n);
  writeln("The number of piles is: ");
  writeln(x);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

BigInt countPartitions(int num) {
  BigInt count = 0;
  auto byOnes = recurrence!((a, n) => a[n-1]+1, int)(1);
  auto byTwos = recurrence!((a, n) => a[n-1]+2, int)(3);
  auto termDiffs = only(1).chain(roundRobin(byOnes, byTwos));

  if (num == 0 || num == 1)
    return BigInt(1);

  auto termIds = termDiffs
      .cumulativeFold!((a, b) => a + b)
      .map!(a => num - a)
    .until!(a => a < 0)
    .array();

  foreach (i, t; termIds.enumerate(2)) {
    count += (i / 2) % 2 == 1 ? memoize!countPartitions(t) : -memoize!countPartitions(t);
  }

  return count;
}
