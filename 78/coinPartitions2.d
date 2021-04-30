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
  timer.start();

  do {
    n++;
    x = memoize!countPartitions3(n);
    writeln(n, " : ", x.digitString.tail(10));
  } while (!(x.length > 6 && x.digitString()[$-6 .. $] == "000000"));

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");
  writeln(n);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

BigInt countPartitions3(int num) {
  BigInt count = 0;
  auto byOnes = recurrence!((a, n) => a[n-1]+1, int)(1);
  auto byTwos = recurrence!((a, n) => a[n-1]+2, int)(3);
  auto termDiffs = only(1).chain(roundRobin(byOnes, byTwos));
  BigInt psum = 0;
  BigInt nsum = 0;

  if (num == 0 || num == 1)
    return BigInt(1);

  auto terms = termDiffs
      .cumulativeFold!((a, b) => a + b)
      .map!(a => num - a)
    .until!(a => a < 0)
    .array();

  foreach (i, t; terms.enumerate(2)) {
    if ((i / 2) % 2 == 1) {
      psum += memoize!countPartitions3(t);
    } else {
      nsum += memoize!countPartitions3(t);
    }
  }

  count = psum - nsum;

  return count;
}

long countPartitions1(long num) {
  long count = 0;

  void inner(long[] numbers, long total) {
    if (total >= num) {
      if (total == num) {
        //writeln(numbers);
        count++;
      }
      return;
    }

    for (long n = numbers[$-1]; n > 0; n--) {
      inner(numbers ~ n, total + n);
    }
  }

  if (num == 0)
    return 1;

  inner([num], 0);

  return count;
}

ulong countPartitions2(ulong num) {
  return memoize!countPartitionsWithSize(num, num);
}

ulong countPartitionsWithSize(ulong num, ulong limit) {
  ulong count = 0;

  if (num == 0 || num == 1 || limit == 1)
    return 1;

  foreach (n; num - limit .. num) {
    //count = (count + memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n))) % 1000000;
    count += memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n));
  }

  return count;
}
