#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.functional;
import std.traits;

enum Figurate {triangular = 1, square, pentagonal, hexagonal, heptagonal, octagonal}
bool delegate(ulong num)[] figurateCheckers;
alias FigGen = ReturnType!(generate!(ReturnType!genFigurateInit));
FigGen[] figurateGenerators;

static this() {
  foreach (f; [EnumMembers!Figurate]) {
    figurateGenerators ~= genFigurateInit(f).generate();
    figurateCheckers ~= isFigurateInit(genFigurateInit(f).generate());
  }
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

bool mayCycle(ulong number) {
  return (number % 100) > 9;
}

bool cyclesWith(ulong a, ulong b) {
  return a % 100 == b / 100;
}

auto genFigurateInit(Figurate mul) {
  ulong last = 0;
  ulong n = 0;

  return delegate ulong() {
    last = last + mul * n + 1;
    n++;
    return last;
  };
}

auto allFiguratesRepresented(ulong[] numbers) {
  Figurate[] singularFiguratesFound;
  Figurate[] multiFiguratesFound;
  Figurate[] figuratesPerNumber;

  foreach (number; numbers) {
    foreach (isFigurate, FigurateType; lockstep(figurateCheckers, [EnumMembers!Figurate])) {
      if (isFigurate(number))
        figuratesPerNumber ~= FigurateType;
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

  return singularFiguratesFound.sort.group.all!(a => a[1] == 1)();
}

ulong[] findSixCyclableFigurates() {
  ulong[] result; 
  auto cyclable4DFigurates = getCyclable4DFigurates();
  auto cyclables = getCyclablesByDigits(cyclable4DFigurates);

  void inner(ulong[] cyclingFigurates, ulong depth) {
    ulong last = cyclingFigurates[$-1];
    ulong first = cyclingFigurates[0];

    if (depth == 6) {
      if (last.cyclesWith(first) && allFiguratesRepresented(cyclingFigurates))
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
  ulong[][] fourDigitFiguratesGrid;

  foreach (f; figurateGenerators)
    fourDigitFiguratesGrid ~= f.find!(a => a > 999).until!(a => a >= 10000).array();

  return fourDigitFiguratesGrid.multiwayUnion.filter!mayCycle.array();
}

ulong[][ulong] getCyclablesByDigits(ulong[] fourDigitNumbers) {
  return fourDigitNumbers
    .chunkBy!((a, b) => a / 100 == b / 100)
    .map!(a => a.front / 100, a => a.array())
    .assocArray();
}

auto isFigurateInit(FigGen generator) {
  bool[ulong] cache = null;

  bool isFigurate(ulong num) {
    auto figurates = refRange(&generator);
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  }

  return &isFigurate;
}
