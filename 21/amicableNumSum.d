#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  long topNum = 10000;
  long amicableSum;

  if (args.length > 1) {
    topNum = args[1].parse!long();
  }

  timer.start();

  amicableSum = iota(1, topNum).filter!(isAmicable).sum();

  timer.stop();
  writefln("The sum of amicable numbers below %s is %s", topNum, amicableSum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

long isAmicable(long number) {
  static long[long] amicableCache;
  long isAmicable;
  long sumFactors;
  long sumFactorsSumFactors;

  if (number < 2)
    return 0;

  if (number in amicableCache)
    return amicableCache[number];

  sumFactors = number.properDivisors.reduce!((a, b) => a + b);
  sumFactorsSumFactors = sumFactors.properDivisors.reduce!((a, b) => a + b);

  if (sumFactorsSumFactors == number && sumFactors != number) {
    isAmicable = sumFactors;
    amicableCache[isAmicable] = number;
  }

  return isAmicable;
}

