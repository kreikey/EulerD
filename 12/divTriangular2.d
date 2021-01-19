#!/usr/bin/env rdmd -I.. -i
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.range;
import std.algorithm;
import kreikey.figurates;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  int topNum = 500;
  auto triangulars = FigGen!(Figurate.triangular)(1);

  if (args.length > 1)
    topNum = args[1].parse!(int);

  timer.start();
  writeln("Highly divisible triangular number");

  auto result = triangulars
    .map!(a => cast(int)a, a => countFactors1(cast(int)a))
    .find!((a, b) => a[1] >= b)(topNum) 
    .front;

  writefln("%(t: %s\tfactor count: %s%)", result);

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

/*
import std.traits;
import kreikey.combinatorics;
alias nextPermutation = kreikey.combinatorics.nextPermutation;

T countFactors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T count;
  T max = number;
  T fac = 1;

  if (number == 1)
    return 1;

  while (fac < max) {
    if (number % fac == 0) {
      count += 2;
      max = number / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  return count;
}

T countFactors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T count = 1;
  auto factorGroups = getPrimeFactorGroups(number);
  bool[] mask = new bool[factorGroups.length];

  foreach (k; 1 .. mask.length+1) {
    mask[] = true;
    mask[0 .. $-k] = false;

    do {
      count += factorGroups
        .zip(mask)
        .filter!(a => a[1])
        .map!(a => a[0][1])
        .fold!((a, b) => a * b)();
    } while (mask.nextPermutation());
  }

  return count;
}
*/
