#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import std.functional;
import kreikey.primes;
import kreikey.intmath;
import kreikey.bytemath;

bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto primes = new Primes!()();
  ulong truncatablePrimesSum = 0;

  writeln("truncatable primes");
  timer.start();

  truncatablePrimesSum += primes
    .drop(4)
    .filter!isTruncatablePrime()
    .take(11)
    .tee!(a => truncatablePrimesSum += a)
    .tail(1)
    .front;

  timer.stop();

  writefln("The sum of all 11 truncatable primes is:\n%s", truncatablePrimesSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isTruncatablePrime(ulong number) {
  auto digits = number.toDigits();

  foreach (n; 1..digits.length)
    if (!digits[n..$].toNumber.isPrime())
      return false;

  foreach (n; 1..digits.length)
    if (!digits[0..$-n].toNumber.isPrime())
      return false;

  return true;
}

