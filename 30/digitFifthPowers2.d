#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.intmath;

enum exponent = 5;

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  immutable static topNumber = 10 ^^ maxDigits;
  ulong[] sums;

  writeln("digit fifth powers");
  timer.start();

  //foreach (x; 2 .. topNumber) {
    //if (x == x.toDigits.map!(a => a ^^ exponent).sum())
      //sums ~= x;
  //}

  sums = iota(2, topNumber)
    .filter!(x => x.toDigits.fold!((a, b) => a + b ^^ exponent)(0uL) == x)
    .array();

  writefln("The numbers that can be written as the sum of fifth powers of their digits are:\n%(%s, %)", sums);
  writefln("sum of these numbers is: %s", sums.sum());
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

ulong getMaxDigits() {
  ulong sum = 0;
  ubyte[] digits;

  do {
    sum = 0;
    digits ~= 9;
    sum = digits.map!(a => a ^^ exponent).sum();
  } while (digits.length <= sum.toDigits().length);

  return digits.length - 1;
}

