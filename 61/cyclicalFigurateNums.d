#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import kreikey.intmath;

void main() {
  StopWatch timer;

  timer.start();

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
  writeln(typeof(allFiguratesRepresented).stringof);

  auto keys = cyclable4DFigurates.map!(a => a % 100).array.sort.uniq.array();

  writeln("chunks");
  auto cyclables = cyclable4DFigurates
    .group!((a, b) => a / 100 == b / 100)
    .map!(a => a[0] / 100)
    .zip(cyclable4DFigurates
        .chunkBy!((a, b) => a / 100 == b / 100)
        .map!array)
    .assocArray();

  ulong maxLen = keys.map!(a => cyclables[a].length).fold!max();
  ulong complexity = 1;

  foreach (i, key; keys.enumerate()) {
    complexity += cyclables[key].length * maxLen ^^ 5;
    writefln("%s: %s: %s", i, key, cyclables[key]);
  }

  writeln("complexity: ", complexity);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool mayCycle(ulong number) {
  return (number % 100) > 9;
}

auto allFiguratesRepresentedInit(ref bool[ulong] isTriangular, ref bool[ulong] isSquare, ref bool[ulong] isPentagonal, ref bool[ulong] isHexagonal, ref bool[ulong] isHeptagonal, ref bool[ulong] isOctagonal) {
  auto allFiguratesRepresented(ulong[] numbers) {
    if (!numbers.any!(n => isTriangular[n])())
      return false;
    if (!numbers.any!(n => isSquare[n])())
      return false;
    if (!numbers.any!(n => isPentagonal[n])())
      return false;
    if (!numbers.any!(n => isHexagonal[n])())
      return false;
    if (!numbers.any!(n => isHeptagonal[n])())
      return false;
    return true;
  }
  return &allFiguratesRepresented;
}

ulong[] findSixCyclableFigurates(ulong[] cyclable4DFigurates, ulong[][ulong] cyclables) {
  ulong[] result; 

  void inner(ulong[] cyclingFigurates, ulong depth) {
  }

  foreach (figurate; cyclable4DFigurates) {
    inner([figurate], 1);
  }

  return result;
}
