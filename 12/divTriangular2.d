#!/usr/bin/env rdmd -I.. -i
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.traits;
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
    .map!(a => a, countFactors)
    .find!(a => a[1] >= topNum) 
    .front;

  writefln("%(t: %s\tfactor count: %s%)", result);

  writeln();
  foreach(n; 1..501) {
    writeln(n, "\t", properDivisors(n));
  }

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

ulong countFactors(ulong num) {
  static ulong[ulong] facCounts;
  ulong count;
  ulong max = num;
  ulong fac = 1;

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
