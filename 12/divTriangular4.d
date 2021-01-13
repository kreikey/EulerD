#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;
import std.range;
import std.algorithm;
import kreikey.combinatorics;
import kreikey.intmath;

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

int triangularize(int n) {
  return n * (n + 1) / 2;
}

int countTrianFactors(int n) {
  int count;

  if (n % 2 == 0)
    count = countFactors(n / 2) * countFactors(n + 1);
  else
    count = countFactors(n) * countFactors((n + 1)/2);

  return count;
}

int countFactors(int num) {
  static int[int] facCounts;
  int count = 1;
  auto factorGroups = getPrimeFactorGroups(num);
  bool[] mask = new bool[factorGroups.length];

  if (num in facCounts)
    return facCounts[num];

  for (ulong k = mask.length - 1; k < ulong.max; k--) {
    mask[] = false;
    mask[k .. $] = true;

    do {
      count += factorGroups
        .zip(mask)
        .filter!(a => a[1])
        .map!(a => a[0])
        .map!(a => a[1])
        .reduce!((a, b) => a * b)();
    } while (mask.nextPermutation());
  }

  facCounts[num] = count;

  return count;
}

int countFactors1(int num) {
  static int[int] facCounts;
  int count;
  int max = num;
  int fac = 1;

  if (num == 1)
    return 1;
  else if (num in facCounts)
    return facCounts[num];

  while (fac < max) {
    if (num % fac == 0) {
      count += 2;
      max = num / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  facCounts[num] = count;

  return count;
}
