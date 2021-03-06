#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;
import std.traits;
import kreikey.digits;
import kreikey.primes;

alias catsPrimeWith = memoize!catsPrimeWith1;
ReturnType!(isPrimeInit!ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  auto p = new Primes!()();

  timer.start();

  writefln("Prime pair sets");
  writeln("Please wait about 4 seconds");
  auto result = smallestPrimePairSet(5);
  writeln(result);
  writeln("The lowest sum for a set of five primes for which any two primes concatenate to produce another prime is:");
  writeln(result.sum());

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto smallestPrimePairSet(ulong length) {
  auto primes = new Primes!()();
  auto primesList = primes.take(length).array();
  ulong[] cattables;
  bool done = false;

  ulong[] findMoreCattables(ulong[] cattablesFound, ulong[] localPrimes) {
    ulong[] localResult = cattablesFound;
    done = localResult.length == length;

    if (done)
      return localResult;

    foreach (i, p; localPrimes.enumerate.retro.until!(a => done))
      if (cattablesFound.all!(a => a.catsPrimeWith(p)))
        localResult = findMoreCattables(cattablesFound ~ p, localPrimes[0..i]);

    return localResult;
  }

  do {
    cattables = findMoreCattables(primesList[$-1..$], primesList[0..$-1]);
    primesList ~= primes.front;
    primes.popFront();
  } while (!done);

  return cattables;
}

bool catsPrimeWith1(ulong left, ulong right) {
  ulong cat1 = toNumber(left.toDigits ~ right.toDigits);

  if (!cat1.isPrime())
    return false;

  ulong cat2 = toNumber(right.toDigits() ~ left.toDigits);

  if (!cat2.isPrime())
    return false;

  return true;
}
