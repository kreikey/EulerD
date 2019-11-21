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
  primes = new Primes!()();
  isPrime = isPrimeInit(primes.save);
}

void main() {
  StopWatch timer;
  ulong truncatablePrimesSum = 0;

  writeln("truncatable primes");
  timer.start();

  auto truncPrimes = primes.drop(4).filter!isTruncatablePrime();
  auto somePrimes = truncPrimes.take(10).array();
  somePrimes ~= truncPrimes.front;
  writefln("%(%d, %)", somePrimes);
  truncatablePrimesSum = somePrimes.sum();

  //foreach (i; 0..10) {
    //writeln(filteredPrimes.front);
    //truncatablePrimesSum += filteredPrimes.front;
    //filteredPrimes.popFront;
  //}

  //writeln(filteredPrimes.front);
  //truncatablePrimesSum += filteredPrimes.front; 

  timer.stop();

  writefln("The sum of all 11 truncatable primes is:\n%s", truncatablePrimesSum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isTruncatablePrime(ulong number) {
  auto digits = number.toDigits();

  foreach (n; 1..digits.length) {
    if (!digits[n..$].toNumber.isPrime())
      return false;
  }

  foreach (n; 1..digits.length) {
    if (!digits[0..$-n].toNumber.isPrime())
      return false;
  }

  return true;
}

