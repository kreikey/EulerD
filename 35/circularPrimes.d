#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import std.functional;
import kreikey.primes;
import kreikey.intmath;

bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto primes = recurrence!((a, n) => a[n-1] + 2)(2uL, 3uL).filter!isPrime;

  timer.start();

  auto circularPrimesCount = primes
    .until!(a => a >= 1_000_000)
    .filter!isCircularPrime
    .tee!(a => write(a, " "))
    .count();
  writeln();

  timer.stop();

  writefln("There are %s circular primes below 1,000,000", circularPrimesCount);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isCircularPrime(ulong number) {
  auto length = number.toDigits().length;

  foreach (n; 0..length-1) {
    number = number.ror();
    if (!number.isPrime())
      return false;
  }

  return true;
}

ulong ror(ulong source) {
  return source.toDigits.dror.toNumber();
}

