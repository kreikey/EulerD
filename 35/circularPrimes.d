#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import std.functional;
import kreikey.primes;
import kreikey.intmath;

bool delegate(ulong) isPrime;
Primes!ulong primes;

static this() {
  primes = new Primes!ulong();
  isPrime = isPrimeInit!ulong(primes.save);
}

void main() {
  StopWatch timer;
  enum top = 1_000_000;

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
    number = number.ror();
    if (!number.isPrime()) {
      return false;
    }
  }

  return true;
}

ulong ror(ulong source) {
  return source.toDigits.dror.toNumber();
}

