#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.functional;
import std.datetime.stopwatch;
import std.traits;
import std.typecons;
import kreikey.primes;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;
import kreikey.combinatorics;
import common;

alias nextPermutation = kreikey.combinatorics.nextPermutation;
//alias permutations = kreikey.combinatorics.permutations;
alias permutations = std.algorithm.permutations;

ReturnType!isPrimeInit isPrime;
ulong[][ulong] cattables;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  timer.start();

  writeln("Getting an upper bound for Prime Pair Sets.");
  writeln("Note. This algorithm does not work. I just thought I'd leave the code here for future reference.");
  auto result = getUpperBound();
  result.each!writeln();
  //writeln(areAllCattable([1237, 4159, 37, 7, 3]));
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong[][] getUpperBound() {
  auto somePrimes = new Primes!ulong().filter!(a => a > 9)();

  auto cattables = somePrimes
    //.tee!writeln
    .map!getSplits
    .joiner
    .filter!arePrime
    .filter!areReverseCattable
    .filter!noReverse
    //.filter!areTwoWayPrimeCattableFirstPair
    //.map!(a => a[0].toNumber(), a => a[1].toNumber())
    .tee!appendCattable
    .map!array
    .joiner
    .map!cattablesMatrix
    .map!(m =>
        //m.map!(r => r.sort.uniq.array())
        m.filter!(r => r.length >= 5)
        .array())
    .filter!(m => m.length >= 5)
    .tee!((m) { m.each!writeln(); writeln("-----------------------------------"); })
    //.map!(m => m.multiwayMerge.group.array.asort!((a, b) => a[1] < b[1])())
    //.tee!(r => writefln("[%(%((%s,%s)%),%)]", r))
    .find!fiveCattables
    //.take(1000)
    //.array
    .front
    ();

  return cattables;
}

bool areTwoWayPrimeCattableFirstPair(Tuple!(uint[], uint[]) digitStrings) {
  static bool[Tuple!(ulong, ulong)] seen;
  uint[] leftDigs = digitStrings[0];
  uint[] rightDigs = digitStrings[1];
  ulong left = leftDigs.toNumber();
  ulong right = rightDigs.toNumber();
  if (!left.isPrime())
    return false;
  if (!right.isPrime())
    return false;
  if (!toNumber(rightDigs ~ leftDigs).isPrime())
    return false;
  if (tuple(right, left) in seen)
    return false;
  seen[tuple(left, right)] = true;
  return true;
}


bool noZeros(ulong number) {
  auto digits = number.toDigits;
  return !digits.any!(d => d == 0);
}

auto getSplits(ulong number) {
  auto digs = number.toDigits();
  ulong left;
  ulong right;
  uint[] leftDigs;
  uint[] rightDigs;
  Tuple!(ulong, ulong)[] splits;

  foreach (i; 1..(digs.length)) {
    leftDigs = digs[0..i];
    rightDigs = digs[i..$];
    if (rightDigs[0] == 0) {
      left = 0uL;
      right = 0uL;
    } else {
      left = leftDigs.toNumber();
      right = rightDigs.toNumber();
    }
    splits ~= tuple(left, right);
  }

  return splits;
}

auto getSplits2(ulong number) {
  auto digs = number.toDigits();
  ulong left;
  ulong right;
  uint[] leftDigs;
  uint[] rightDigs;
  Tuple!(uint[], uint[])[] splits;

  foreach (i; 1..(digs.length)) {
    leftDigs = digs[0..i];
    rightDigs = digs[i..$];
    if (rightDigs[0] == 0) {
      leftDigs = [0];
      rightDigs = [0];
    }
    splits ~= tuple(leftDigs, rightDigs);
  }

  return splits;
}

bool arePrime(Tuple!(ulong, ulong) numbers) {
  return numbers[0].isPrime() && numbers[1].isPrime();
}

bool foundReverse(Tuple!(ulong, ulong) numbers) {
  static bool[Tuple!(ulong, ulong)] seen;
  auto revNumbers = reverse(numbers);

  if (revNumbers in seen)
    return true;

  seen[numbers] = true;

  return false;
}

bool noReverse(Tuple!(ulong, ulong) numbers) {
  static bool[Tuple!(ulong, ulong)] seen;
  auto revNumbers = reverse(numbers);

  if (revNumbers in seen)
    return false;

  seen[numbers] = true;

  return true;
}

void appendCattable(Tuple!(ulong, ulong) primes) {
  cattables[primes[0]] ~= primes[1];
  cattables[primes[1]] ~= primes[0];
}

void printCattables(Tuple!(ulong, ulong) primes) {
  if (primes[0] in cattables)
    writefln("%s: %s", primes[0], cattables[primes[0]]);
  if (primes[1] in cattables)
    writefln("%s: %s", primes[1], cattables[primes[1]]);
}

ulong[] fiveCattables(ulong[][] primes) {
  size_t[] chosenIndexes = new size_t[primes.length];
  ulong[][] matrix;
  Tuple!(ulong, uint)[] groups;
  ulong[] result;

  chosenIndexes[$-5..$] = 1;
  //writeln("--------------------");
  do {
    //writeln(chosenIndexes);
    matrix = zip(chosenIndexes, primes).filter!(a => a[0]).map!(a => a[1].asort()).array();
    //matrix.each!writeln();
    groups = matrix.multiwayMerge.group.array.asort!((a, b) => a[1] < b[1])();
    //writefln("[%(%((%s,%s)%),%)]", groups);
    //writeln("****************");
    if (groups.count!(a => a[1] >= 5)() >= 5) {
      //writefln("[%(%((%s,%s)%),%)]", groups);
      result = groups.filter!(a => a[1] >= 5).map!(a => a[0]).array();
      //writeln(result);
      break;
    }
  } while(nextPermutation(chosenIndexes));
  //writeln("--------------------");
  //writeln(result);
  return result;
}

ulong[] cattablesCandidate(ulong[][] primes) {
  ulong[] result;
  primes.each!asort();
  auto groups = primes.multiwayMerge.group.array.asort!((a, b) => a[1] < b[1])();
  //writeln(groups);
  result = groups.filter!(a => a[1] >= 5).map!(a => a[0]).array();
  //writeln("groups:");
  //writeln(result);
  return result;
}

ulong[][] cattablesMatrix(ulong prime) {
  ulong[][] result;
  ulong[] row;

  if (prime in cattables) {
    result ~= prime ~ cattables[prime];

    foreach (c; cattables[prime]) {
      row ~= c;
      if (c in cattables) {
        row ~= cattables[c];
      }
      result ~= row;
      row = [];
    }
  }

  return result;
}

bool areAllCattable(ulong[] primes) {
  foreach (p; primes) {
    foreach (q; primes) {
      if (p == q)
        continue;
      if (!p.catsPrimeWith(q))
        return false;
    }
  }
  return true;
}

bool areReverseCattable(Tuple!(ulong, ulong) primes) {
  auto number = toNumber(primes[1].toDigits() ~ primes[0].toDigits());

  return isPrime(number);
}
