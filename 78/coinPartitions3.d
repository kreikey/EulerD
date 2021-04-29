#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.functional;

void main() {
  StopWatch timer;
  uint n = 0;
  ulong x = 0;
  
  writeln("Coin partitions");
  timer.start();

  do {
    n++;
    x = memoize!countPartitions4(n, 6);
    //writeln(n, " : ", x);
  } while (x != 0);

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");
  writeln(n);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto countPartitions4Init() {
  int count = 0;
  int digitsMod = 10 ^^ digitsToKeep;
  int[] ps = [1];
  int[] ids = [0];
  bool[] signs = [false];

  int countPartitions4(int digitsToKeep) {
    terms = indexed(ps, ids);

    foreach (s; signs) {
      count = s ? count - terms.front : count + terms.front;
    }

    ids[]++;
    if () {
      ids ~= 0;
    }
    ps ~= count;
    signs ~= signs.back ? false : true;

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
