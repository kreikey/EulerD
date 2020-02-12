#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.array;
import std.conv;
import std.traits;
import std.functional;
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;

alias primeCatsWith = memoize!primeCatsWith1;
ReturnType!isPrimeInit isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;

  writeln("Prime pair sets");

  timer.start();

  writeln(isPrime(73));
  writeln(primeCatsWith(7, 3));

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool primeCatsWith1(ulong left, ulong right) {
  ulong cat1 = toNumber(left.toDigits ~ right.toDigits);

  if (!cat1.isPrime())
    return false;

  ulong cat2 = toNumber(right.toDigits() ~ left.toDigits);

  if (!cat2.isPrime())
    return false;

  return true;
}
