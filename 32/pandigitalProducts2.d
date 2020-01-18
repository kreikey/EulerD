#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;
import kreikey.intmath;
import kreikey.bytemath;

void main() {
  StopWatch timer;
  uint[] digits = iota(1u, 10).array();
  ulong sum = 0;

  writeln("pandigital products");
  timer.start();

  sum = digits
    .permutations
    .map!(a => a.array())
    .map!(a => a[0..5], a => a[5..$].toNumber())
    .filter!(a => isProductIdentity(a.expand))
    .map!(a => a[1])
    .uniq
    .sum();

  timer.stop();
  writeln("The sum of all products whose multiplicand/multiplier/product identity can be written as 1 through 9 pandigital is:\n", sum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

bool isProductIdentity(uint[] digits, ulong number) {
  foreach (i; 1..digits.length) {
    if (digits[0..i].toNumber() * digits[i..$].toNumber() == number)
      return true;
  }

  return false;
}
