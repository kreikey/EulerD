#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.functional;

void main() {
  StopWatch timer;
  ulong x = 0;
  
  writeln("Coin partitions");

  for (uint n = 1;; n++) {
    x = memoize!countPartitionsSlow(n);
    writeln(n, " : ", x);
  }
}

uint countPartitionsSlow(uint num) {
  return memoize!countPartitionsWithSize(num, num);
}

uint countPartitionsWithSize(uint num, uint limit) {
  uint count = 0;

  if (num == 0 || num == 1 || limit == 1)
    return 1;

  foreach (n; num - limit .. num) {
    count = (count + memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n))) % 1000000;
  }

  return count;
}
