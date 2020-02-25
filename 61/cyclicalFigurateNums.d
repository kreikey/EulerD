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

  //auto triangulars = sequence!((a, n) => n * (n + 1) / 2).dropOne();
  //auto squares = sequence!((a, n) => n * n).dropOne();
  //auto pentagonals = sequence!((a, n) => n * (3 * n - 1) / 2).dropOne();
  //auto hexagonals = sequence!((a, n) => n * (2 * n - 1)).dropOne();
  //auto heptagonals = sequence!((a, n) => n * (5 * n - 3) / 2).dropOne();
  //auto octagonals = sequence!((a, n) => n * (3 * n - 2)).dropOne();

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
  bool[ulong] isOctagonals = iota(1000uL, 10000).zip(repeat(false)).assocArray();

  auto fourDigitTriangulars = triangulars.tee!(a => isTriangular[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitSquares = squares.tee!(a => isSquare[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitPentagonals = pentagonals.tee!(a => isPentagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHexagonals = hexagonals.tee!(a => isHexagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHeptagonals = heptagonals.tee!(a => isHeptagonal[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitOctagonals = octagonals.tee!(a => isOctagonals[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();

  writeln(fourDigitTriangulars.length);
  writeln(fourDigitSquares.length);
  writeln(fourDigitPentagonals.length);
  writeln(fourDigitHexagonals.length);
  writeln(fourDigitHeptagonals.length);
  writeln(fourDigitOctagonals.length);
  writeln("unmerged length");
  writeln(fourDigitTriangulars.length + fourDigitSquares.length + fourDigitPentagonals.length + fourDigitHexagonals.length + fourDigitHeptagonals.length + fourDigitOctagonals.length);

  writeln(factorial(6) * fourDigitTriangulars.length * fourDigitSquares.length * fourDigitPentagonals.length * fourDigitHexagonals.length * fourDigitHeptagonals.length * fourDigitOctagonals.length);

  auto fourDigitFigurates = merge(fourDigitTriangulars, fourDigitSquares, fourDigitPentagonals, fourDigitHexagonals, fourDigitHeptagonals, fourDigitOctagonals).uniq.array();

  writeln(fourDigitFigurates);
  writeln("merged length");
  writeln(fourDigitFigurates.length);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

