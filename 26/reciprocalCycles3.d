#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;

import std.range;

void main(string[] args) {
  StopWatch timer;
  ulong end = 1000;
  ulong start = 2;

  if (args.length > 1)
    end = args[1].parse!ulong();

  timer.start();

  auto resTup = iota(start, end)
    .map!(a => a, reptendLength)
    .fold!((a, b) => a[1] > b[1] ? a : b)();

  writefln("The number between %s and %s whose reciprocal has the longest reptend is:", start, end);
  writefln("denominator: %s\nreptend length: %s", resTup[0], resTup[1]);

  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

long reptendLength(ulong denom) {
  ulong num = 10;
  ulong quo;
  ulong rem;
  ulong savedRem;
  ulong transLength;
  ulong[] factors;
  ulong reptendLength;

  void popFront() {
    quo = num / denom;
    rem = num % denom;
    num = rem * 10;
  }

  void calcPrimeFactors(ulong number) {
    ulong n = 2;

    while (number > 1) {
      while (number % n == 0) {
        factors ~= n;
        number /= n;
      }
      n++;
    }
  }

  void calcTransientLength() {
    if (factors.any!(a => a == 2 || a == 5))
      transLength = factors.filter!(a => a == 2 || a == 5).group.reduce!((a, b) => a[1] > b[1] ? a : b)[1];
    else
      transLength = 0;
  }

  calcPrimeFactors(denom);
  calcTransientLength();
  popFront();

  foreach (i; 0 .. transLength) {
    popFront();
  }

  savedRem = rem;

  do {
    popFront();
    reptendLength++;
  } while(rem != savedRem);

  if (factors.all!(a => a == 2 || a == 5))
    reptendLength = 0;

  return reptendLength;
}
