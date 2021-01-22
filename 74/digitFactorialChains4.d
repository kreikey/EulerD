#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.functional;
import std.concurrency;
import std.typecons;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;
int[] cycleRoots = [169, 871, 872];

void main(string[] args) {
  StopWatch timer;
  int maxDigs = 6;
  int chainLength = 60;

  if (args.length > 1) {
    try {
      chainLength = args[1].parse!int();
    } catch (Exception e) {
      writeln(e.msg);
      writeln("Can't parse that argument! Falling back to default.");
    }
  }

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", repeat(9u).take(maxDigs).array.toNumber() + 1);
  writeln("with 60 non-repeating terms is:");

  writeln(countFactorialDigitChainsWithLength2(maxDigs, chainLength));

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong countFactorialDigitChainsWithLength(int maxDigs, int chainLength) {
  uint[][] cycleMembersArray = cycleRoots
    .map!factorialDigitChain
    .join
    .map!toDigits
    .array();

  auto cycleMembers = cycleMembersArray
    .map!(a => cast(const)a)
    .zip(repeat(true))
    .assocArray();

  auto sortedCycleMembers = cycleMembersArray
    .map!(a => cast(const)a.asort())
    .zip(repeat(true))
    .assocArray();

  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit!uint(1, maxDigs));
  uint[][] specialDigits;
  ulong number = 0;

  foreach (digits; sortedDigits) {
    if (digits in sortedCycleMembers) {
      specialDigits ~= digits;
      continue;
    }

    if (digits.factorialDigitChainLength() == chainLength) {
      number += digits.countValidPermutations();
    }
  }

  auto localChainLength = 0;

  foreach (digits; specialDigits) {
    localChainLength = digits.factorialDigitChainLength();
    if (digits in cycleMembers) {
      if (localChainLength == chainLength - 1) {
        number += digits.countValidPermutations() - 1;
      } else if (localChainLength == chainLength) {
        number++;
      }
    } else if (digits in sortedCycleMembers) {
      if (localChainLength == chainLength) {
        number += digits.countValidPermutations() - 1;
      } else if (localChainLength == chainLength + 1) {
        number++;
      }
    }
  }

  return number;
}

ulong countFactorialDigitChainsWithLength2(int maxDigs, int chainLength) {
  uint[][] cycleMembersArray = cycleRoots
    .map!factorialDigitChain
    .join
    .map!toDigits
    .array();

  auto cycleMembers = cycleMembersArray
    .map!(a => cast(const)a)
    .zip(repeat(true))
    .assocArray();

  auto sortedCycleMembers = cycleMembersArray
    .map!(a => cast(const)a.asort())
    .zip(repeat(true))
    .assocArray();

  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit!uint(1, maxDigs));
  uint[][] specialDigits;
  auto localChainLength = 0;

  ulong number = sortedDigits
    .tee!((a) {
        if (a in sortedCycleMembers)
          specialDigits ~= a;
          })
    .filter!(a => a !in sortedCycleMembers && a.factorialDigitChainLength() == chainLength)
    .map!countValidPermutations
    .sum();

  number += specialDigits
    .filter!(a => a !in cycleMembers && a.factorialDigitChainLength() == chainLength)
    .map!(a => a.countValidPermutations() - 1)
    .sum();

  number += specialDigits
    .filter!(a => a !in cycleMembers && a.factorialDigitChainLength() == chainLength + 1)
    .map!(a => 1)
    .sum();

  number += specialDigits
    .filter!(a => a in cycleMembers && a.factorialDigitChainLength() == chainLength - 1)
    .map!(a => a.countValidPermutations() - 1)
    .sum();

  number += specialDigits
    .filter!(a => a in cycleMembers && a.factorialDigitChainLength() == chainLength)
    .map!(a => 1)
    .sum();

  return number;
}


ulong countValidPermutations(uint[] digits) {
  return digits.permutations.array.sort.uniq.filter!(a => a[0] != 0).count();
}

int[] factorialDigitChain(int source) {
  int[] chain;
  int index = 0;
  int[int] factorialSumIndex = [source:index];
  int sum = source.factDigSum();
  index++;

  chain ~= source;

  while (sum !in factorialSumIndex) {
    chain ~= sum;
    factorialSumIndex[cast(const)sum] = index;
    sum = sum.factDigSum();
    index++;
  }

  return chain;
}

int factorialDigitChainLength(uint[] source) {
  int index = 0;
  int[uint[]] factorialSumIndex = [source:index];
  uint[] sumDigs = source.factDigSumDigs();
  index++;

  while (sumDigs !in factorialSumIndex) {
    factorialSumIndex[cast(const)sumDigs] = index;
    sumDigs = sumDigs.factDigSumDigs();
    index++;
  }

  return index;
}

uint[] factDigSumDigs(uint[] source) {
  return source.map!factorial.sum.toDigits();
}

int factDigSum(int source) {
  return source.toDigits.map!factorial.sum();
}
