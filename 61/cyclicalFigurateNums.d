#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import kreikey.intmath;

enum Figurate {Triangular, Square, Pentagonal, Hexagonal, Heptagonal, Octagonal}

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

auto allFiguratesRepresentedInit(ref bool[ulong] isTriangular, ref bool[ulong] isSquare, ref bool[ulong] isPentagonal, ref bool[ulong] isHexagonal, ref bool[ulong] isHeptagonal, ref bool[ulong] isOctagonal) {
  auto allFiguratesRepresented(ulong[] numbers) {
    Figurate[] singularFiguratesFound;
    Figurate[] multiFiguratesFound;
    Figurate[] figuratesPerNumber;
    Figurate[] totalFiguratesFound;
    Figurate[] uniqueFiguratesFound;

    foreach (number; numbers) {
      if (isTriangular[number])
        figuratesPerNumber ~= Figurate.Triangular;
      if (isSquare[number])
        figuratesPerNumber ~= Figurate.Square;
      if (isPentagonal[number])
        figuratesPerNumber ~= Figurate.Pentagonal;
      if (isHexagonal[number])
        figuratesPerNumber ~= Figurate.Hexagonal;
      if (isHeptagonal[number])
        figuratesPerNumber ~= Figurate.Heptagonal;
      if (isOctagonal[number])
        figuratesPerNumber ~= Figurate.Octagonal;

      if (figuratesPerNumber.length > 1)
        multiFiguratesFound ~= figuratesPerNumber;
      else
        singularFiguratesFound ~= figuratesPerNumber;

      figuratesPerNumber = [];
    }

    totalFiguratesFound = multiFiguratesFound ~ singularFiguratesFound;

    if (totalFiguratesFound.sort.uniq.count() < 6)
      return false;

    if (singularFiguratesFound.sort.group.canFind!(a => a[1] > 1)())
      return false;

    return true;
  }

  return &allFiguratesRepresented;
}

ulong[] findSixCyclableFigurates() {
  ulong[] result; 
  auto triangulars = recurrence!((a, n) => a[n-1] + n + 1)(1);
  auto squares = recurrence!((a, n) => a[n-1] + 2*n + 1)(1);
  auto pentagonals = recurrence!((a, n) => a[n-1] + 3*n + 1)(1);
  auto hexagonals = recurrence!((a, n) => a[n-1] + 4*n + 1)(1);
  auto heptagonals = recurrence!((a, n) => a[n-1] + 5*n + 1)(1);
  auto octagonals = recurrence!((a, n) => a[n-1] + 6*n + 1)(1);
  bool[ulong] isTriangular = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  bool[ulong] isSquare = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  bool[ulong] isPentagonal = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  bool[ulong] isHexagonal = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  bool[ulong] isHeptagonal = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  bool[ulong] isOctagonal = iota(1000uL, 10000).zip(repeat(false)).assocArray();
  auto fourDigitTriangulars = triangulars.tee!(a => isTriangular[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitSquares = squares.tee!(a => isSquare[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitPentagonals = pentagonals.tee!(a => isPentagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHexagonals = hexagonals.tee!(a => isHexagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHeptagonals = heptagonals.tee!(a => isHeptagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitOctagonals = octagonals.tee!(a => isOctagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto cyclable4DFigurates = merge(fourDigitTriangulars, fourDigitSquares, fourDigitPentagonals, fourDigitHexagonals, fourDigitHeptagonals, fourDigitOctagonals).uniq.filter!mayCycle.array();
  auto allFiguratesRepresented = allFiguratesRepresentedInit(isTriangular, isSquare, isPentagonal, isHexagonal, isHeptagonal, isOctagonal);
  
  auto cyclables = cyclable4DFigurates
    .group!((a, b) => a / 100 == b / 100)
    .map!(a => a[0] / 100)
    .zip(cyclable4DFigurates
        .chunkBy!((a, b) => a / 100 == b / 100)
        .map!array)
    .assocArray();

  void inner(ulong[] cyclingFigurates, ulong depth) {
    if (depth == 6) {
      if (allFiguratesRepresented(cyclingFigurates) && cyclingFigurates[$-1]%100 == cyclingFigurates[0]/100) {
        result = cyclingFigurates;
      }
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
