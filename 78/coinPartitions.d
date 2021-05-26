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
    x = memoize!countPartitions(n, 6);
    //writeln(n, " : ", x);
  } while (x != 0);

  writeln("The lowest number of coins that can be separated into a number of piles divisible by one million is:");
  writeln(n);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong countPartitions(int num, int digitsToKeep) {
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
      count = (count + memoize!countPartitions(term, digitsToKeep)) % digitsMod;
    } else {
      count = ((count + digitsMod) - memoize!countPartitions(term, digitsToKeep)) % digitsMod;
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
