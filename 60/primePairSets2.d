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
  auto primesList = primes.take(2).array();
  ulong[][ulong] cattablesTable;
  ulong[] cattables;
  bool done = false;

  ulong[] getCattables(ulong key) {
    ulong[]* result = key in cattablesTable;
    return result ? *result : [];
  }

  ulong[] findMoreCattables(ulong[] cattablesFound, ulong[] localPrimes) {
    ulong[] localResult = cattablesFound;
    done = localResult.length == length;

    if (done)
      return localResult;

    foreach (p; localPrimes.until!(a => done))
      if (cattablesFound[0..$-1].map!(a => getCattables(a)).join.count(p) == cattablesFound.length - 1)
        localResult = memoize!findMoreCattables(cattablesFound ~ p, getCattables(p));

    return localResult;
  }

  do {
    foreach (p; primesList[0..$-1])
      if (p.catsPrimeWith(primesList[$-1]))
        cattablesTable[p] ~= primesList[$-1];

    foreach (p; primesList.until!(a => done))
      cattables = memoize!findMoreCattables([p], getCattables(p));

    if (done)
      continue;

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
