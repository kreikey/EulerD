#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.functional;
import std.concurrency;
import std.typecons;
import std.functional;
import kreikey.digits;
import kreikey.intmath;
import kreikey.util;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;
immutable int[] cycleRoots = [169, 871, 872];
immutable int[][] cycleMembersArray = cycleRoots.map!factorialDigitChain.array();
int[immutable(int)] cycleMembers;

static this() {
  cycleMembers = cycleMembersArray
    .map!(a => zip(a, repeat(cast(int)a.length)))
    .join
    .assocArray();
}

// This is a generally correct and fast variation of solution 1

void main(string[] args) {
  StopWatch timer;
  int chainLength = 60;
  int limit = 1000000;

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
  writefln("The number of digit factorial chains below %s", limit);
  writefln("with %s non-repeating terms is:", chainLength);

  ulong number = iota!int(1, limit)
    .filter!(a => a.factorialDigitChainLength() == chainLength)
    .count();

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

int factorialDigitChainLength(int source) {
  if (source in cycleMembers)
    return cycleMembers[source];

  int sumDigs = source.factDigSum();

  if (sumDigs == source)
    return 1;

  return 1 + memoize!factorialDigitChainLength(sumDigs);
}

int factDigSum(int source) {
  return source.toDigits.map!factorial.sum();
}
