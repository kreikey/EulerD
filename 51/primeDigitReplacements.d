#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.primes;
import kreikey.intmath;
import kreikey.combinatorics;
import std.array;

alias permutations = kreikey.combinatorics.permutations;
alias nextPermutation = kreikey.combinatorics.nextPermutation;

typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main(string[] args) {
  StopWatch timer;
  auto primes = new Primes!ulong();
  int family = 8;

  if (args.length > 1)
    family = args[1].parse!int();

  timer.start();

  auto smallest = primes
    .map!toDigits
    .find!(a => a.length == 2)
    .chunkBy!((a, b) => a.length == b.length)
    .map!(a => a.array
        .maskings
        .sort
        .group
        .array
        .map!(a => a[1], a => a[0])
        .array())
    .joiner
    .find!(a => a[0] == family)
    .tee!writeln()
    .front[1]
    .replacements
    .map!toNumber
    .find!isPrime
    .front;

  writefln("The smallest prime that's part of an %s prime family", family);
  writeln("when part of the number is replaced is:");
  writeln(smallest);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] maskings(uint[][] source) {
  size_t n = source[0].length;
  uint[] mask = new uint[n];
  mask[] = 0;
  uint[][] result;
  uint[] row;
  
  foreach (k; iota(1, n)) {
    mask[$-k..$] = 10;
    do {
      foreach (e; source) {
        row = e.dup;
        if (applyMask(row, mask))
          result ~= row;
      }
    } while (mask.nextPermutation());
    mask[] = 0;
  }

  return result;
}

bool applyMask(ref uint[] digits, uint[] mask) {
  ulong seedNdx = mask.countUntil(10);
  uint seed = digits[seedNdx];

  foreach (ref d, m; lockstep(digits, mask)) {
    if (m == 10 && d != seed)
      return false;
  }

  foreach (ref d, m; lockstep(digits, mask)) {
    if (m == 10)
      d = 10;
  }

  return true;
}

uint[][] replacements(uint[] digits) {
  auto ones = iota(0, 10).array();
  uint[][] result;
  uint[] row;

  foreach (d; 0..10) {
    row = digits.dup;
    if (d == 0 && row[0] == 10)
      continue;
    foreach (ref e; row)
      if (e == 10)
        e = d;
    result ~= row;
  }
  return result;
}
