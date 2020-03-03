#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.traits;
import kreikey.intmath;

enum Figurate {Triangular, Square, Pentagonal, Hexagonal, Heptagonal, Octagonal}

alias Triangulars = recurrence!((a, n) => a[n-1] + n + 1, ulong);
alias Squares = recurrence!((a, n) => a[n-1] + 2*n + 1, ulong);
alias Pentagonals = recurrence!((a, n) => a[n-1] + 3*n + 1, ulong);
alias Hexagonals = recurrence!((a, n) => a[n-1] + 4*n + 1, ulong);
alias Heptagonals = recurrence!((a, n) => a[n-1] + 5*n + 1, ulong);
alias Octagonals = recurrence!((a, n) => a[n-1] + 6*n + 1, ulong);

ReturnType!(isFigurateInit!Triangulars) isTriangular;
ReturnType!(isFigurateInit!Squares) isSquare;
ReturnType!(isFigurateInit!Pentagonals) isPentagonal;
ReturnType!(isFigurateInit!Hexagonals) isHexagonal;
ReturnType!(isFigurateInit!Heptagonals) isHeptagonal;
ReturnType!(isFigurateInit!Octagonals) isOctagonal;

static this() {
  isTriangular = isFigurateInit!Triangulars();
  isSquare = isFigurateInit!Squares();
  isPentagonal = isFigurateInit!Pentagonals();
  isHexagonal = isFigurateInit!Hexagonals;
  isHeptagonal = isFigurateInit!Heptagonals();
  isOctagonal = isFigurateInit!Octagonals();
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

auto allFiguratesRepresented(ulong[] numbers) {
  Figurate[] singularFiguratesFound;
  Figurate[] multiFiguratesFound;
  Figurate[] figuratesPerNumber;

  foreach (number; numbers) {
    if (isTriangular(number))
      figuratesPerNumber ~= Figurate.Triangular;
    if (isSquare(number))
      figuratesPerNumber ~= Figurate.Triangular;
    if (isSquare(number))
      figuratesPerNumber ~= Figurate.Square;
    if (isPentagonal(number))
      figuratesPerNumber ~= Figurate.Pentagonal;
    if (isHexagonal(number))
      figuratesPerNumber ~= Figurate.Hexagonal;
    if (isHeptagonal(number))
      figuratesPerNumber ~= Figurate.Heptagonal;
    if (isOctagonal(number))
      figuratesPerNumber ~= Figurate.Octagonal;

    if (figuratesPerNumber.length > 1)
      multiFiguratesFound ~= figuratesPerNumber;
    else
      singularFiguratesFound ~= figuratesPerNumber;

    figuratesPerNumber = [];
  }

  auto totalFiguratesFound = multiFiguratesFound ~ singularFiguratesFound;

  if (totalFiguratesFound.sort.uniq.count() < 6)
    return false;

  return (singularFiguratesFound.sort.group.all!(a => a[1] == 1)());
}

ulong[] findSixCyclableFigurates() {
  ulong[] result; 
  auto cyclable4DFigurates = getCyclable4DFigurates();
  auto cyclables = getCyclablesByDigits(cyclable4DFigurates);

  void inner(ulong[] cyclingFigurates, ulong depth) {
    if (depth == 6) {
      if (cyclingFigurates[$-1]%100 == cyclingFigurates[0]/100 && allFiguratesRepresented(cyclingFigurates))
        result = cyclingFigurates;
      return;
    }

    foreach (figurate; cyclables[cyclingFigurates[$-1] % 100]) {
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

  fourDigitFiguratesGrid ~= Triangulars(1).find!(a => a > 999).until!(a => a >= 10000).array();
  fourDigitFiguratesGrid ~= Squares(1).find!(a => a > 999).until!(a => a >= 10000).array();
  fourDigitFiguratesGrid ~= Pentagonals(1).find!(a => a > 999).until!(a => a >= 10000).array();
  fourDigitFiguratesGrid ~= Hexagonals(1).find!(a => a > 999).until!(a => a >= 10000).array();
  fourDigitFiguratesGrid ~= Heptagonals(1).find!(a => a > 999).until!(a => a >= 10000).array();
  fourDigitFiguratesGrid ~= Octagonals(1).find!(a => a > 999).until!(a => a >= 10000).array();

  return fourDigitFiguratesGrid.multiwayUnion.filter!mayCycle.array();
}

ulong[][ulong] getCyclablesByDigits(ulong[] fourDigitNumbers) {
  return fourDigitNumbers
    .chunkBy!((a, b) => a / 100 == b / 100)
    .map!(a => a.front / 100, a => a.array())
    .assocArray();
}

auto isFigurateInit(alias generator)() {
  auto temp = generator(1);
  auto temp2 = new typeof(temp);
  *temp2 = temp;
  auto figurates = refRange(temp2);
  bool[ulong] cache = null;

  bool isFigurate(ulong num) {
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  }

  return &isFigurate;
}
