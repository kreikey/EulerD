#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.functional;
import std.traits;
import std.format;

enum Figurate {triangular = 1, square, pentagonal, hexagonal, heptagonal, octagonal}
bool delegate(ulong num)[] figurateCheckers;

template FigGen(Figurate mul) {
  alias FigGen = partial!(recurrence!(mixin(genFigurateLambda(mul)), ulong), 1uL);
}

static this() {
  foreach (f; EnumMembers!Figurate)
    figurateCheckers ~= isFigurateInit!(FigGen!f)();
}

void main() {
  StopWatch timer;

  timer.start();

  writefln("Cyclical figurate numbers");
  auto result = findSixCyclableFigurates();
  writefln("result: %s", result);
  writefln("sum: %s", result.sum());

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

string genFigurateLambda(int mul) {
  return q{(s, n) => s[n-1] + %s * n + 1}.format(mul);
}

bool mayCycle(ulong number) {
  return (number % 100) > 9;
}

bool cyclesWith(ulong a, ulong b) {
  return a % 100 == b / 100;
}

auto allUniqFigurates(ulong[] numbers) {
  Figurate[] singularFiguratesFound;
  Figurate[] multiFiguratesFound;
  Figurate[] figuratesPerNumber;

  foreach (number; numbers) {
    foreach (isFigurate, f; lockstep(figurateCheckers, [EnumMembers!Figurate])) {
      if (isFigurate(number))
        figuratesPerNumber ~= f;
    }

    if (figuratesPerNumber.length > 1)
      multiFiguratesFound ~= figuratesPerNumber;
    else
      singularFiguratesFound ~= figuratesPerNumber;

    figuratesPerNumber = [];
  }

  auto totalFiguratesFound = multiFiguratesFound ~ singularFiguratesFound;

  if (totalFiguratesFound.sort.uniq.count() < 6)
    return false;

  return singularFiguratesFound
    .sort
    .group
    .all!(a => a[1] == 1)();
}

ulong[] findSixCyclableFigurates() {
  ulong[] result; 
  auto cyclable4DFigurates = getCyclable4DFigurates();
  auto cyclables = getCyclablesByDigits(cyclable4DFigurates);

  void inner(ulong[] cyclingFigurates, ulong depth) {
    ulong last = cyclingFigurates[$-1];
    ulong first = cyclingFigurates[0];

    if (depth == 6) {
      if (last.cyclesWith(first) && cyclingFigurates.allUniqFigurates())
        result = cyclingFigurates;
      return;
    }

    foreach (figurate; cyclables[last % 100]) {
      inner(cyclingFigurates ~ figurate, depth + 1);
      if (result.length != 0)
        break;
    }
  }

  foreach (figurate; cyclable4DFigurates) {
    inner([figurate], 1);
    if (result.length != 0)
      break;
  }

  return result;
}

ulong[] getCyclable4DFigurates() {
  ulong[][] fourDigFigurates;

  foreach (f; EnumMembers!Figurate)
    fourDigFigurates ~= FigGen!f
      .find!(a => a > 999)
      .until!(a => a >= 10000)
      .array();

  return fourDigFigurates
    .multiwayUnion
    .filter!mayCycle
    .array();
}

ulong[][ulong] getCyclablesByDigits(ulong[] fourDigitNumbers) {
  return fourDigitNumbers
    .chunkBy!((a, b) => a / 100 == b / 100)
    .map!(a => a.front / 100, array)
    .assocArray();
}

auto isFigurateInit(alias generator)() {
  auto temp = generator();
  bool[ulong] cache = null;

  return delegate(ulong num) {
    auto figurates = refRange(&temp);
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  };
}
