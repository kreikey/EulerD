#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import std.conv;
import std.experimental.checkedint;
import kreikey.intmath;
import kreikey.digits;
import kreikey.bigint;

void main() {
  StopWatch timer;
  BigInt result;
  ulong digitCount;
  ulong matchCount;
  enum maxBase = getMaxBase();
  enum maxExponent = getMaxExponent(maxBase);

  timer.start();
  writeln("Powerful digit counts");
  writefln!"max base: %s"(maxBase);
  writefln!"max exponent: %s"(maxExponent);

  matchCount =iota(BigInt(1), BigInt(maxBase + 1))
    .map!(base => iota(1, maxExponent + 1uL)
        .map!(exponent => base ^^ exponent, e => base, e => e))
    .join
    .count!(n => n[0].countDigits() == n[2]);

  writeln("Then number of n-digit positive integers which are also an nth power is:");
  writeln(matchCount);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong getMaxBase() {
  ulong base = 1;
  ulong result = 0;

  do {
    result = (++base) ^^ 2;
  } while (countDigits(result) <= 2);

  return --base;
}

ulong getMaxExponent(ulong maxBase) {
  ulong exponent = 1;
  ulong result = maxBase;

  do {
    result *= maxBase;
    exponent++;
  } while (countDigits(result) == exponent);

  return exponent;
}
