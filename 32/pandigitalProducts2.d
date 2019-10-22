#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;

void main() {
  StopWatch timer;
  int[] digits = iota(1, 10).array();
  ulong sum = 0;

  writeln("pandigital products");
  timer.start();

  sum = digits
    .permutations
    .map!(a => a.array())
    .map!(a => tuple(a[0..5], a[5..$].toNumber()))
    .filter!(a => isProductIdentity(a.expand))
    .map!(a => a[1])
    .uniq
    .sum();

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

bool isProductIdentity(int[] digits, ulong number) {
  foreach (i; 1..digits.length) {
    if (digits[0..i].toNumber() * digits[i..$].toNumber() == number)
      return true;
  }

  return false;
}
