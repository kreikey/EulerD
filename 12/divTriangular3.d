#!/usr/bin/env rdmd -I.. -i
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.range;
import std.algorithm;
import kreikey.figurates;
import kreikey.intmath;
import kreikey.combinatorics;

alias nextPermutation = kreikey.combinatorics.nextPermutation;

void main(string[] args) {
  StopWatch timer;
  int topNum = 500;
  auto triangulars = FigGen!(Figurate.triangular)(1);

  if (args.length > 1)
    topNum = args[1].parse!(int);

  timer.start();
  writeln("Highly divisible triangular number");

  auto result = triangulars
    .map!(a => a, countFactors2)
    .find!((a, b) => a[1] >= b)(topNum) 
    .front;

  writefln("%(t: %s\tfactor count: %s%)", result);

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

ulong countFactors2(ulong num) {
  ulong count = 1;
  auto factorGroups = getPrimeFactorGroups(num);
  bool[] mask = new bool[factorGroups.length];

  for (ulong k = mask.length - 1; k < ulong.max; k--) {
    mask[] = false;
    mask[k .. $] = true;

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

ulong countFactors1(ulong num) {
  ulong count;
  ulong max = num;
  ulong fac = 1;

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
