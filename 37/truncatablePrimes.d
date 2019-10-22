#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
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

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1_000_000;

  if (args.length > 1)
    limit = args[1].parse!ulong();

  writeln("truncatable primes");
  timer.start();

  auto truncatablePrimesSum = primes
    .until!(a => a >= 1_000_000)
    .drop(4)
    .filter!isTruncatablePrime
    .tee!(a => write(a, " "))
    .sum();
  writeln();

  timer.stop();

  writefln("The sum of truncatable primes below %s is:\n%s", limit, truncatablePrimesSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isTruncatablePrime(ulong number) {
  auto digits = number.toDigits();

  foreach (n; 1..digits.length) {
    //writeln(digits[n..$]);
    if (!digits[n..$].toNumber.isPrime()) {
      return false;
    }
  }

  foreach (n; 1..digits.length) {
    //writeln(digits[0..$-n]);
    if (!digits[0..$-n].toNumber.isPrime()) {
      return false;
    }
  }

  return true;
}

