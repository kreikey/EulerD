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

immutable int[] cycleRoots = [169, 871, 872];
immutable int[][] cycleMembersArray = cycleRoots.map!factorialDigitChain.array();
int[const(uint)[]] cycleMembers;

static this() {
  cycleMembers = cycleMembersArray
    .map!(a => zip(a, repeat(cast(int)a.length)))
    .join
    .map!(a => cast(const)a[0].toDigits(), a => a[1])
    .assocArray();
}

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
  writefln("with %s non-repeating terms is:", chainLength);

  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit!uint(1, maxDigs));
  auto chainLengthGroups = factDigChainLenGroupsInit();

  ulong number = sortedDigits
    .map!chainLengthGroups
    .join
    .filter!(a => a[0] == chainLength)
    .map!(a => a[1])
    .sum();

  writeln(number);
  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
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
  auto temp = source in cycleMembers;
  if (temp !is null)
    return *temp;

  uint[] sumDigs = source.factDigSumDigs();

  if (sumDigs == source)
    return 1;

  return 1 + memoize!factorialDigitChainLength(sumDigs);
}

uint[] factDigSumDigs(uint[] source) {
  return source.map!factorial.sum.toDigits();
}

int factDigSum(int source) {
  return source.toDigits.map!factorial.sum();
}

auto factDigChainLenGroupsInit() {
  auto sortedCycleMembers = cycleMembersArray
    .join
    .map!(a => cast(const)a.toDigits.asort())
    .zip(repeat(true))
    .assocArray();

  auto factDigChainLenGroups(uint[] source) {
    Tuple!(int, int)[] chainLengthGroups;
    int chainLength = source.factorialDigitChainLength();
    int permCount = source.countDistinctNumberPermutations();

    if (source in cycleMembers) {
      // The number is a certain chain length and all its permutations are one greater
      chainLengthGroups ~= tuple(chainLength, 1);
      chainLengthGroups ~= tuple(chainLength + 1, permCount - 1);
    } else if (source in sortedCycleMembers) {
      // All permutations are a certain chain length except the one permutation in the chain
      chainLengthGroups ~= tuple(chainLength - 1, 1);
      chainLengthGroups ~= tuple(chainLength, permCount - 1);
    } else {
      // The number and all its permutations share the same chain length
      chainLengthGroups ~= tuple(chainLength, permCount);
    }

    return chainLengthGroups;
  }

  return &factDigChainLenGroups;
}

/*
int countDistinctPermutations(uint[] source) {
  import kreikey.intmath : factorial;

  auto groups = source.group.array();
  int numerator = (cast(int)source.length).factorial();
  int denominator = groups.map!(a => a[1].factorial()).fold!((a, b) => a * b);
  int basicCount = numerator / denominator;

  return basicCount;
}

int countDistinctNumberPermutations(uint[] source) {
  int nonZeroCount = cast(int)source.filter!(a => a != 0).count();

  return source.countDistinctPermutations() * nonZeroCount / cast(int)source.length;
}

ulong countDistinctNumberPermutations(uint[] digits) {
  return digits.permutations.array.sort.uniq.filter!(a => a[0] != 0).count();
}
*/
