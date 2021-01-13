#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;
import std.range;
import std.algorithm;
import std.traits;
import kreikey.intmath;
import kreikey.combinatorics;

alias nextPermutation = kreikey.combinatorics.nextPermutation;

void main(string[] args) {
  StopWatch timer;
  int trian;
  int topNum = 500;
  int n = 1;

  if (args.length > 1)
    topNum = args[1].parse!(int);

  timer.start();

  while (countTrianFactors(n) <= topNum) {
    n++;
  }

  writefln("n: %s t: %s factor count: %s", n, triangularize(n), countTrianFactors(n));
  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");

}

T triangularize(T)(T n)
if (isIntegral!T) {
  return n * (n + 1) / 2;
}

T countTrianFactors(T)(T n)
if (isIntegral!T) {
  T count;

  alias countFactorsFast = memoize!(countFactors1!T);

  if (n % 2 == 0)
    count = countFactorsFast(n / 2) * countFactorsFast(n + 1);
  else
    count = countFactorsFast(n) * countFactorsFast((n + 1)/2);

  return count;
}

/*
T countFactors1(T = int)(T num)
if (isIntegral!T) {
  T count;
  T max = num;
  T fac = 1;

  if (num == 1)
    return 1;

  while (fac < max) {
    if (num % fac == 0) {
      count += 2;
      max = num / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  return count;
}

T countFactors2(T = int)(T num) 
if (isIntegral!T) {
  T count = 1;
  auto factorGroups = getPrimeFactorGroups(num);
  bool[] mask = new bool[factorGroups.length];

  foreach (k; 1 .. mask.length + 1) {
    mask[] = true;
    mask[0 .. $ - k] = false;

    do {
      count += factorGroups
        .zip(mask)
        .filter!(a => a[1])
        .map!(a => a[0][1])
        .reduce!((a, b) => a * b)();
    } while (mask.nextPermutation());
  }

  return count;
}
*/
