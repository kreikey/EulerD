#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.math;
import std.typecons;
import std.traits;
import std.conv;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;
import kreikey.digits;
import kreikey.primes;

alias isPermutation = kreikey.combinatorics.isPermutation;
typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

// number: 9983167 totient: 9973816 ratio: 1.00094

void main() {
  StopWatch timer;
  ulong top = 9999999;

  timer.start();
  writeln("generate numbers");

  //auto tumber = findTotientPermutation(top, sqrt(real(top)).to!ulong());
  //number = tumber[0];
  //totient = tumber[1];
  //ratio = real(number)/totient;

  //writefln("number: %s totient: %s ratio: %s", number, totient, ratio);
  auto numbers = getNumbers(top, sqrt(real(top)).to!ulong());
  auto myFile = File("numbers2.txt", "w");
  numbers.each!(a => myFile.writeln(a))();

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong[] getNumbers(ulong top, ulong topFactor) {
  auto primes = new Primes!ulong();
  //real minRatio = real.max;
  //ulong bestNumber = top;
  //ulong bestTotient = 0;
  auto initialNumbers = primes
    .save
    .until!(a => a > topFactor)
    .array();
  ulong[] numbers;
  ulong count = 0;

  void inner(ulong[] factors) {
    ulong number = factors.fold!((a, b) => a * b)(1uL);
    auto currentFactors = primes
      .save
      .find!(a => a > factors[$-1])
      .until!(a => a > top / number)
      .array();
    //auto totient = getTotient(number);
    //auto ratio = real(number)/totient;

    if (factors.length > 1) {
      //writeln(factors);
      //myFile.writeln(number);
      numbers ~= number;
      count++;
      if (count % 1000 == 0)
        writeln(count);
    }

    //if (number != 1 && totient.isPermutation(number) && ratio < minRatio) {
      //minRatio = ratio;
      //bestNumber = number;
      //bestTotient = totient;
    //}

    foreach (factor; currentFactors.retro())
      inner(factors ~ factor);
  }
  
  numbers.reserve(6000000);

  foreach (initial; initialNumbers.retro())
    inner([initial]);

  return numbers;
}

void getNumbers(ulong upper) {
  getNumbers(upper, upper);
}

auto getTotientPermutation2(ulong top) {
  auto primes = new Primes!ulong();
  ulong product;
  ulong totient;

  for (ulong low = primes.countUntil!(a => a >= sqrt(real(top)))() - 1; low < ulong.max; low--) {
    writeln(primes.front);
    for (ulong high = primes.countUntil!(a => a >= real(top)/primes[low])() - 1; high > low; high--) {
      product = primes[low] * primes[high];
      totient = getTotient(product);
      writeln(primes[low], " ", primes[high], " ", product, " ", totient, " ", real(product)/totient);
      if (isPermutation(product, totient))
        return tuple(product, totient);
    }
  }

  return tuple(0uL, 0uL);
}
