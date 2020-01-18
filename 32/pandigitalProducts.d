#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.intmath;
import kreikey.bytemath;
import kreikey.combinatorics;

alias nextPermutation = kreikey.combinatorics.nextPermutation;

void main() {
  StopWatch timer;
  uint[] digits = iota!uint(1, 10).array();
  uint[] productDigs = [];
  ulong left = 0;
  ulong right = 0;
  ulong product = 0;
  ulong sum = 0;

  writeln("pandigital products");
  timer.start();

  do {
    if (digits[0..4] == productDigs)
      continue;

    foreach (i; 5..(digits.length-1)) {
      left = digits[4..i].toNumber();
      right = digits[i..$].toNumber();
      product = digits[0..4].toNumber();

      if (left * right == product) {
        productDigs = digits[0..4].dup;
        sum += product;
      }
    }
  } while (digits.nextPermutation());

  timer.stop();
  writeln("The sum of all products whose multiplicand/multiplier/product identity can be written as 1 through 9 pandigital is:\n", sum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

