#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import kreikey.intmath;
import kreikey.linkedlist;
import kreikey.bigint;
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
  BigInt x = 1;

  do {
    //writeln(n, " : ", countPartitions2(n));
    x = countPartitions1(n);
    writeln(n, " : ", x);
    n++;
  } while (n <= 2001);


  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countPartitions2(uint num) {
  ulong count = 0;

  void inner(uint[] numbers, uint total) {

    if (total >= num) {
      if (total == num) {
        //writeln(numbers);
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

BigInt countPartitions1(uint num) {
  return memoize!countPartitionsWithSize(num, num);
}

BigInt countPartitionsWithSize(uint num, uint size) {
  BigInt count = 0;

  if (num == 0 || num == 1 || size == 1)
    return BigInt(1);

  if (size > num)
    size = num;

  foreach (n; num - size .. num) {
    count += memoize!countPartitionsWithSize(n, num - n);
  }

  return count;
}
