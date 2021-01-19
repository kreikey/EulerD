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

void main() {
  StopWatch timer;
  int maxDigs = 6;
  int chainLength = 4;

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", repeat(9u).take(maxDigs).array.toNumber() + 1);
  writeln("with 60 non-repeating terms is:");

  writeln(countFactorialDigitChainsWithLength(maxDigs, chainLength));

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong countFactorialDigitChainsWithLength(int maxDigs, int length) {
  ulong number = 0;

  int[][] cycles = cycleRoots
    .map!factorialDigitChain
    .array();

  bool[uint[]] cycleMembers = cycles
    .join
    .map!(a => cast(const)a.toDigits.asort())
    .zip(repeat(true))
    .assocArray();

  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit!uint(1, maxDigs));

  //writeln("normal matches");
  writeln(cycles);

  number = sortedDigits
    .filter!(a => a !in cycleMembers)
    .map!(a => a, factorialDigitChainLength)
    .filter!(a => a[1] == length)
    //.tee!writeln
    .map!(a => countNumberPermutations(a[0]))
    .sum();

  //writeln("special matches");

  auto cycleDigitsLengths = cycles
    .join
    .map!(a => a.toDigits)
    .map!(a => a, a => a.factorialDigitChainLength())
    .array();

  writeln(cycleDigitsLengths);

  number += cycleDigitsLengths
    .filter!(a => a[1] == length)
    //.tee!writeln
    .count();

  writeln();

  number += cycleDigitsLengths
    //.map!(a => zip(a[0].permutations.dropOne(), repeat(a[1] + 1)))
    .map!(a => a[0].countNumberPermutations() - 1, a => a[1] + 1)
    //.join
    //.filter!(a => a[0][0] != 0)
    //.tee!writeln
    //.filter!(a => a[1] == length && a[0][0] != 0)
    //.count();
    .filter!(a => a[1] == length)
    .map!(a => a[0])
    .sum();
    //.fold!((a, b) => a[0] + b[0])(tuple(0, 0));

  return number;
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

int countNumberPermutations(uint[] source) {
  auto groups = source.group.array();
  int nonZeroCount = cast(int)source.filter!(a => a != 0).count();

  int numerator = (cast(int)source.length).factorial();
  int denominator = groups.map!(a => a[1].factorial()).fold!((a, b) => a * b);
  int basicCount = numerator / denominator;
  //int leadingZeroRatio = numerator / zeroCount.factorial();

  return basicCount * nonZeroCount / cast(int)source.length;
}
