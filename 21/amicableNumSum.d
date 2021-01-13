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

  writeln("Amicable numbers");

  amicableSum = iota(2, topNum)
    .filter!isAmicable
    .tee!writeln
    .sum();

  timer.stop();
  writefln("The sum of amicable numbers below %s is %s", topNum, amicableSum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

bool isAmicable(long number) {
  static bool[long] amicableCache;
  bool isAmicable;
  long sumFactors;
  long sumFactorsSumFactors;

  if (number < 2)
    return 0;

  if (number in amicableCache)
    return amicableCache[number];

  sumFactors = number.getProperDivisors.reduce!((a, b) => a + b);
  sumFactorsSumFactors = sumFactors.getProperDivisors.reduce!((a, b) => a + b);

  if (sumFactorsSumFactors == number && sumFactors != number) {
    isAmicable = true;
    amicableCache[number] = true;
    amicableCache[sumFactors] = true;
  }

  return isAmicable;
}

