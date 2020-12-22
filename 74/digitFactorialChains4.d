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
ulong[] cycleRoots = [169, 871, 872];

void main() {
  StopWatch timer;
  ulong limit = 1000000;

  timer.start();

  writeln("Digit factorial chains");
  writefln("The number of digit factorial chains below %s", limit);
  writeln("with 60 non-repeating terms is:");

  auto maxDigs = (limit - 1).countDigits();

  writeln(countFactorialDigitChainsWithLength(maxDigs, 60));

  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong countFactorialDigitChainsWithLength(ulong maxDigs, ulong length) {
  ulong number = 0;
  ulong[][] cycles = cycleRoots
    .map!factorialDigitChain
    .array();
  bool[uint[]] cycleMembers = cycles
    .join
    .map!(a => a.toDigits.asort())
    .map!(a => cast(const(uint)[])a)
    .zip(repeat(true))
    //.tee!writeln
    .assocArray();
  auto sortedDigits = new Generator!(uint[])(getSortedDigitsInit(1, maxDigs));

  number = sortedDigits
    .filter!(a => a !in cycleMembers)
    .map!(a => a, factorialDigitChainLength)
    .filter!(a => a[1] == length)
    //.tee!(a => writefln("%(%s %s%)", a))
    .map!(a => a[0].permutations())
    .join
    .sort
    .uniq
    .filter!(a => a[0] != 0)
    .count();

  auto cycleDigitsLengths = cycles
    .join
    .map!toDigits
    .map!(a => a, a => a.factorialDigitChainLength())
    //.tee!(a => writefln("%(%s, %s%)", a))
    .array();

  number += cycleDigitsLengths
    .filter!(a => a[1] == length)
    .count();

  number += cycleDigitsLengths
    .map!(a => zip(a[0].permutations.dropOne(), repeat(a[1] + 1)))
    .join
    //.tee!(a => writefln("%(%s, %s%)", a))
    .filter!(a => a[1] == length)
    .count();

  return number;
}

ulong[] factorialDigitChain(ulong source) {
  ulong[] chain;
  ulong index = 0;
  ulong[ulong] factorialSumIndex = [source:index];
  ulong sum = source.factDigSum();
  index++;

  chain ~= source;

  while (sum !in factorialSumIndex) {
    chain ~= sum;
    factorialSumIndex[cast(immutable)sum] = index;
    sum = sum.factDigSum();
    index++;
  }

  return chain;
}

ulong factorialDigitChainLength(uint[] source) {
  ulong index = 0;
  ulong[uint[]] factorialSumIndex = [source:index];
  uint[] sumDigs = source.factDigSumDigs();
  index++;

  while (sumDigs !in factorialSumIndex) {
    factorialSumIndex[cast(immutable)sumDigs] = index;
    sumDigs = sumDigs.factDigSumDigs();
    index++;
  }

  return index;
}

uint[] factDigSumDigs(uint[] source) {
  return source.map!factorial.sum.toDigits();
}

ulong factDigSum(ulong source) {
  return source.toDigits.map!factorial.sum();
}
