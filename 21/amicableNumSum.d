#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string args[]) {
  StopWatch sw;
  long topNum = 10000;
  long amicableSum;

  if (args.length > 1) {
    topNum = args[1].parse!(long);
  }

  sw.start();

  amicableSum = iota(1, topNum).filter!(isAmicable).sum();

  sw.stop();
  writefln("The sum of amicable numbers below %s is %s", topNum, amicableSum);
  writefln("finished in %s milliseconds", sw.peek.msecs());
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

  sumFactors = number.getFactors.reduce!((a, b) => a + b);
  sumFactorsSumFactors = sumFactors.getFactors.reduce!((a, b) => a + b);

  if (sumFactorsSumFactors == number && sumFactors != number) {
    isAmicable = sumFactors;
    amicableCache[isAmicable] = number;   // put it in the associative array
  }

  return isAmicable;
}

