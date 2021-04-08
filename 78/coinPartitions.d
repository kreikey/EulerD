#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.linkedlist;
import std.functional;

struct NumSum {
  uint[] numbers = [];
  ulong sum = 0;
}

void main() {
  StopWatch timer;
  
  writeln("Counting summations");

  timer.start();

  uint n = 1;
  ulong x = 1;

  do {
    writeln(n, " : ", countPartitions3(n));
    //writeln(n, " : ", memoize!countPartitions2(n));
    n++;
  } while (x % 1000000 != 0);

  countPartitions3(5);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countPartitions3(uint num) {
  ulong count = 0;

  void inner(uint[] numbers, uint total) {

    if (total >= num) {
      if (total == num) {
        writeln(numbers);
        count++;
      }
      return;
    }

    for (uint n = numbers[$-1]; n > 0; n--) {
      inner(numbers ~ n, total + n);
    }
  }

  for (uint n = num; n > 0; n--)
    inner([n], n);

  return count;
}

ulong countPartitions1(uint num) {
  return countPartitionsWithSize(num, num);
}

ulong countPartitions2(uint num) {
  ulong count = 0;
  uint left = num, right = 0;

  if (num < 2)
    return 1;

  do {
    if (left >= right) {
      count += memoize!countPartitions1(right);
    } else {
      count += memoize!countPartitionsWithSize(right, left);
    }
    left--;
    right++;
  } while (left > 0);

  return count;
}

ulong countPartitionsWithSize(uint num, uint size) {
  ulong count = 0;

  bool inner(uint piece, uint runningSum) {
    if (runningSum == num) {
      count++;
      return true;
    }

    for (uint n = 1; n <= piece; n++) {
      if (inner(n, runningSum + n))
        break;
    }

    return false;
  }

  inner(size, 0);

  return count;
}

ulong countPartitionsWithPartitions(uint num, uint partitions) {
  uint count = 0;

  uint first = num - (partitions - 1);
  uint second = 1;
  
  while (first >= second) {
    second++;
    first--;
  }

  return count;
}
