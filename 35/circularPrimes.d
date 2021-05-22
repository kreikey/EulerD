#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import std.functional;
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;

bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  enum top = 1_000_000;
  auto primes = new Primes!()();

  writeln("circular primes: ");
  timer.start();

  auto circularPrimesCount = primes
    .until!(a => a >= top)
    .filter!isCircularPrime
    .tee!(a => write(a, " "))
    .count();
  writeln();

  timer.stop();

  writefln("There are %s circular primes below %s", circularPrimesCount, top);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isCircularPrime(ulong number) {
  auto length = number.toDigits().length;

  foreach (n; 0..length-1) {
    number = number.dror();
    if (!number.isPrime())
      return false;
  }

  return true;
}

