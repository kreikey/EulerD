#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

void main() {
  StopWatch timer;
  ulong count = 0;
  uint[] coins = [200, 100, 50, 20, 10, 5, 2, 1];
  uint maxSum = 200;

  timer.start();

  count = countCoinSums(coins, maxSum);

  writefln("The number of possible coin sums is %s", count);
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

ulong countCoinSums(uint[] coins, uint maxSum) {
  ulong countCoinSumsInternal(size_t coinID, uint sum) {
    if (sum > maxSum)
      return 0;
    else if (sum == maxSum)
      return 1;
    else {
      ulong count = 0;
      foreach (i; coinID..coins.length)
        count += countCoinSumsInternal(i, sum + coins[i]);
      return count;
    }
  }

  return countCoinSumsInternal(0, 0);
}
