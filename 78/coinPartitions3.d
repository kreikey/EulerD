#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;

void main() {
  StopWatch timer;
  
  writeln("Coin partitions");
  timer.start();

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");

  multiCountPartitionsInit(6)
    .generate
    .until(0, OpenRight.no)
    .count
    .writeln();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto multiCountPartitionsInit(uint digitsToKeep) {
  uint digitsMod = 10 ^^ digitsToKeep;
  uint[] ps = [1];
  uint[] ids = [0];
  auto byOnes = recurrence!((a, n) => a[n-1]+1, uint)(1);
  auto byTwos = recurrence!((a, n) => a[n-1]+2, uint)(3);
  auto appendIntervals = roundRobin(byOnes, byTwos);
  uint sameLengthCount = 0;

  uint countPartitions4() {
    uint count = 0;
    auto terms = indexed(ps, ids);

    for (auto i = 0, subtract = false; i < terms.length; i += 2, subtract = !subtract) {
      count = ((count + digitsMod) + (subtract ? -terms[i] : terms[i])) % digitsMod;
    }

    for (auto i = 1, subtract = false; i < terms.length; i += 2, subtract = !subtract) {
      count = ((count + digitsMod) + (subtract ? -terms[i] : terms[i])) % digitsMod;
    }

    ps ~= count;
    sameLengthCount++;
    ++ids[];

    if (sameLengthCount == appendIntervals.front) {
      ids ~= 0;
      sameLengthCount = 0;
      appendIntervals.popFront();
    }

    return count;
  }

  return &countPartitions4;
}

ulong countPartitions3(int num, int digitsToKeep) {
  ulong count = 0;
  ulong digitsMod = 10 ^^ digitsToKeep;
  int term = num - 1;
  ulong i = 0;
  int a = 1;
  int b = 3;

  if (num == 0 || num == 1)
    return ulong(1);

  do {
    if ((i / 2) % 2 == 0) {
      count = (count + memoize!countPartitions3(term, digitsToKeep)) % digitsMod;
    } else {
      count = ((count + digitsMod) - memoize!countPartitions3(term, digitsToKeep)) % digitsMod;
    }
    if (i % 2 == 1) {
      term -= b;
      b += 2;
    } else {
      term -= a;
      a++;
    }
    i++;
  } while (term >= 0);

  return count;
}

uint countPartitions2(uint num) {
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

ulong countPartitions1(uint num) {
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

  inner([num], 0);

  return count;
}
