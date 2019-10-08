#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

alias asortDescending = (ubyte[] a) {a.sort!((b, c) => c < b)(); return a;};
alias asort = (ubyte[] a) {a.sort(); return a;};
enum exponent = 5;

void main() {
  StopWatch timer;
  enum maxDigits = getMaxDigits();
  immutable static topNumber = 10 ^^ maxDigits;
  ulong[] sums;

  timer.start();
  sums = 
    iota(2, topNumber)
    .map!(a => a.toUbytes.asort())
    .array
    .sort
    .uniq
    .map!((a => a), (a => a.fold!((a, b) => a + b ^^ exponent)(0uL)))
    .filter!(a => a[0] == a[1].toUbytes.asort())
    .map!(a => a[1])
    .array();

  sort(sums);

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
  } while (digits.length <= sum.toUbytes().length);

  return digits.length - 1;
}

ubyte[] toUbytes(ulong source) {
  ulong maxPowTen = 1;
  ubyte[] result;

  if (source == 0) {
    return [0];
  }

  while (maxPowTen <= source) {
    maxPowTen *= 10;
  } 

  maxPowTen /= 10;
 
  while (maxPowTen > 0) {
    result ~= cast(ubyte)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
}