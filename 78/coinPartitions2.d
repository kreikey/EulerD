#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import std.functional;
import kreikey.intmath;
import kreikey.linkedlist;

void main() {
  StopWatch timer;
  
  writeln("Counting summations");

  timer.start();

  uint n = 1;
  uint x = 1;

  do {
    //writeln(n, " : ", countPartitions3(n));
    x = countPartitions1(n);
    writeln(n, " : ", x);
    n++;
  //} while (x != 0);
  } while (n <= 100);

  //countPartitions1(5750);
  //countPartitions1(74);
  //countPartitions(359);
  //countPartitions(449);
  //countPartitions(518);
  //countPartitions(599);
  //countPartitions(776);
  //countPartitions(1949);
  //countPartitions(2499);

  //numbers ending in:
  //99, 76, 49
  //four zeros at the end

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint countPartitions3(uint num) {
  uint count = 0;

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
uint countPartitions1(uint num) {
  return memoize!countPartitionsWithSize(num, num);
}

uint countPartitionsWithSize(uint num, uint limit) {
  uint count = 0;

  if (num == 0 || num == 1 || limit == 1)
    return 1;

  foreach (n; num - limit .. num) {
    //count = (count + memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n))) % 1000000;
    count += memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n));
  }

  return count;
}

// 100 : 190569292

/*
uint countPartitionsRange(uint num) {
  if (num == 0)
    return 1;

  return (memoize!countPartitionsRange(num - 1) + countPartitions1(num)) % 1000000;
}
*/

//ulong countPartitionsRange(uint min, uint max) {
  //if (num == 0)
    //return countPartitions1(num);

  //return memoize!countPartitionsRange(num - 1) + memoize!countPartitions1(num);
//}
