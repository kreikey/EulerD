#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import kreikey.intmath;
import kreikey.digits;
import kreikey.combinatorics;
import kreikey.primes;
import std.functional;

alias permutations = kreikey.combinatorics.permutations;

typeof(areSubstringsDivisibleInit()) areSubstringsDivisible;

static this() {
  areSubstringsDivisible = areSubstringsDivisibleInit();
}

void main() {
  StopWatch timer;

  timer.start();

  writeln("Sub-string Divisibility");
  auto primes = new Primes!(uint)();
  auto somePrimes = primes.save.take(7).array();

  auto pandigital = iota(10u).array();
  auto perms = permutations(pandigital);

  auto sum = perms
    .filter!areSubstringsDivisible
    .map!toNumber
    .tee!writeln
    .sum();

  timer.stop();

  writeln("The sum of all 0 to 9 pandigital numbers, assuming 1-based index, where:");
  writeln("Digits [2,3,4] is divisible by 2, and");
  writeln("Digits [3,4,5] is divisible by 3, and");
  writeln("Digits [4,5,6] is divisible by 5, and");
  writeln("Digits [5,6,7] is divisible by 7, and");
  writeln("Digits [6,7,8] is divisible by 11, and");
  writeln("Digits [7,8,9] is divisible by 13, and");
  writeln("Digits [8,9,10] is divisible by 17 is:");
  writeln(sum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto areSubstringsDivisibleInit() {
  auto primes = new Primes!(uint)();
  auto somePrimes = primes.save.take(7).array();

  bool areSubstringsDivisible(uint[] digits) {
    foreach (i, p; lockstep(iota(1u, 8), somePrimes))
      if (digits[i..i+3].toNumber() % p != 0)
        return false;

    return true;
  }

  return &areSubstringsDivisible;
}
