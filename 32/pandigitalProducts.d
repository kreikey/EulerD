#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;

void main() {
  StopWatch timer;
  int[] digits = iota(1, 10).array();
  int[] productDigs = [];
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

int[] toDigits(ulong source) {
  ulong maxPowTen = 1;
  int[] result;

  if (source == 0) {
    return [0];
  }

  while (maxPowTen <= source) {
    maxPowTen *= 10;
  } 

  maxPowTen /= 10;

  while (maxPowTen > 0) {
    result ~= cast(int)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
}

ulong toNumber(int[] digits) {
  ulong result = 0;

  int i = 0;
  foreach (n; digits.retro()) {
    result += n * 10 ^^ i;
    i++;
  }

  return result;
}

