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
  ulong number;
  ulong totient;
  real ratio;
  ulong[] factors;

  timer.start();
  writeln("Totient permutation");

  //iota(2uL, 10000000)
    //.retro
    //.map!(a => a, getTotient)
    //.find!(a => a[0].isPermutation(a[1]))
    //.front
    //.writefln!("%(number: %s totient: %s%)");

  //auto numbers = iota(2uL, 100000)
    //.map!(a => a, distinctPrimeFactors)
    //.array
    //.sort!((a, b) => a[1] < b[1])
    //.uniq!((a, b) => a[1] == b[1])
    //.cache
    //.map!(a => a[0], a => getTotient(a[0]), a => a[1])
    //.map!(a => a[0], a => a[1], a => real(a[0])/a[1], a => a[2])
    //.array
    //.asort!((a, b) => a[2] < b[2])();

  //foreach(n; numbers) {
    //writefln("%s %s %s %s", n.expand);
  //}

  //auto myFile = File("numbers.txt", "w");
  //ulong[] numbers;

  //for (ulong n = 2; n < 10000000; n++) {
    //if (n % 100000 == 0)
      //writeln(n / 100000, "%");
    //if (isPrime(n))
      //continue;
    //if (n.primeFactors.group.any!(a => a[1] != 1))
      //continue;
    //myFile.writeln(n);
  //}

  //auto inputFile = File("numbers.txt", "r");
  //auto numbers = inputFile
    //.byLine
    //.map!(to!ulong)
    //.array();

  //auto outputFile = File("totients.txt", "w");

  //foreach (n; numbers) {
    //totient = getTotient(n);
    //outputFile.writeln(n, " ", totient);
  //}
  
  // 193 * 197 = 38021
  // if top = 38021 and topFactor = 38021 then we iterate from 38021 down to 2 for the first factor.
  // if top = 38021 and topFactor = 193 then we iterate from 193 down to 2 for the first factor. 
  // then the second factor iterates from 38021/193 = 197 down to the first factor.
  // 197 * 197 = 38809 
  // if top = 38809 and topFactor = 38809 then we iterate from 38809 down to 2 for the first factor.
  // if top = 38809 and topFactor = 197 then we iterate from 197 down to 2 for the first factor.
  // then the second factor iterates from 197 to 197, resulting in 0 iterations.
  // The next iteration for the first factor is 193. Then the first iteration for the second factor is 199.
  // So we have the first set of factors as only one low factor, but that's OK. 


  //writeln(getTotient(1321));
  //writeln(getTotient(3437503));
  //number = findTotientPermutation(top, cast(ulong)(sqrt(real(top))));
  //totient = getTotient(number);
  //ratio = real(number)/totient;

  auto numTotientRatios = File("totients.txt")
    .byLine
    .map!(a => a.split(" ").map!(to!ulong).array())
    .map!(a => a[0], a => a[1], a => real(a[0])/a[1])
    .array();

  numTotientRatios.sort!((a, b) => a[2] < b[2])();

  auto sortedTotientsFile = File("sortedTotients.txt", "w");
  numTotientRatios
    .each!(a => sortedTotientsFile.writefln!"%(%s %s %s%)"(a))();


  //writefln("number: %s totient: %s ratio: %s", number, totient, ratio);
  //writeln(distinctPrimeFactors(number));
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong findTotientPermutation(ulong top, ulong topFactor) {
  auto primes = new Primes!ulong();
  real minRatio = real.max;
  ulong bestNumber = top;

  bool inner(ulong[] factors) {
    ulong number = factors.fold!((a, b) => a * b)(1uL);
    auto currentFactors = primes
      .save
      .find!(a => a > factors[$-1])
      .until!(a => a > min(top / number, topFactor))
      .array();
    auto totient = getTotient(number);
    auto ratio = real(number)/totient;
    //ulong bestFactorLength = ulong.max;
    
    //writeln(factors);
    if (number != 1 && totient.isPermutation(number) && ratio < minRatio) {
      writeln(number, " ", totient, " ", real(number)/totient);
      //minRatio = ratio;
      bestNumber = number;
      //bestFactorLength = currentFactors.length;
    }

    foreach (factor; currentFactors.retro())
      if (inner(factors ~ factor)) {
        //break;
      }
 //&& currentFactors.length >= bestFactorLength
    return ratio > minRatio;
  }
  
  inner([1]);

  return bestNumber;
}

void findTotientPermutation(ulong upper) {
  findTotientPermutation(upper, upper);
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
