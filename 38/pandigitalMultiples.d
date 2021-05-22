#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;
import kreikey.intmath;
import kreikey.digits;
import kreikey.combinatorics;

alias nextPermutation = kreikey.combinatorics.nextPermutation;

void main() {
  StopWatch timer;

  writeln("pandigital multiples");
  timer.start();

  uint[] digits = iota!uint(9, 0, -1).array();
  ulong largest = 0;

  while (!digits.isConcatProduct())
    digits.nextPermutation!((a, b) => a > b)();
  
  largest = digits.toNumber();

  timer.stop();
  writefln("The largest 1-9 pandigital concatenated product is: %s", largest);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

bool isConcatProduct(uint[] digits) {
  ulong num = 0;
  uint[] result = [];

  foreach (i; 1..5) {
    foreach (n; 1..10) {
      num = digits[0..i].toNumber() * n;
      result ~= num.toDigits();

      if (result.length >= 9 || result != digits[0..result.length])
        break;
    }

    if (result == digits)
      return true;

    result = [];
  }

  return false;
}
