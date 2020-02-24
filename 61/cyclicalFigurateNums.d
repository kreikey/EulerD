#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import kreikey.intmath;

void main() {
  StopWatch timer;

  auto triangulars = sequence!((a, n) => n * (n + 1) / 2).dropOne();
  auto squares = sequence!((a, n) => n * n).dropOne();
  auto pentagonals = sequence!((a, n) => n * (3 * n - 1) / 2).dropOne();
  auto hexagonals = sequence!((a, n) => n * (2 * n - 1)).dropOne();
  auto heptagonals = sequence!((a, n) => n * (5 * n - 3) / 2).dropOne();
  auto octagonals = sequence!((a, n) => n * (3 * n - 2)).dropOne();

  //auto triangulars = recurrence!((a, n) => a[n-1] + n + 1)(1);
  //auto squares = recurrence!((a, n) => a[n-1] + 2*n + 1)(1);
  //auto pentagonals = recurrence!((a, n) => a[n-1] + 3*n + 1)(1);
  //auto hexagonals = recurrence!((a, n) => a[n-1] + 4*n + 1)(1);
  //auto heptagonals = recurrence!((a, n) => a[n-1] + 5*n + 1)(1);
  //auto octagonals = recurrence!((a, n) => a[n-1] + 6*n + 1)(1);

  bool[ulong] triangularTable;
  bool[ulong] squareTable;
  bool[ulong] pentagonalTable;
  bool[ulong] hexagonalTable;
  bool[ulong] heptagonalTable;
  bool[ulong] octagonalsTable;

  auto fourDigitTriangulars = triangulars.tee!(a => triangularTable[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitSquares = squares.tee!(a => squareTable[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitPentagonals = pentagonals.tee!(a => pentagonalTable[a] = true).find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHexagonals = hexagonals.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHeptagonals = heptagonals.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitOctagonals = octagonals.find!(a => a > 999).until!(a => a >= 10000).array();

  auto isTriangular = isFigurateInit(triangularTable);
  auto isSquare = isFigurateInit(squareTable);
  iota(1, 1000).map!(a => a, isTriangular).each!writeln();
  writeln(fourDigitTriangulars.length);
  writeln(fourDigitSquares.length);
  writeln(fourDigitPentagonals.length);
  writeln(fourDigitHexagonals.length);
  writeln(fourDigitHeptagonals.length);
  writeln(fourDigitOctagonals.length);

  timer.start();
  writeln(factorial(6) * fourDigitTriangulars.length * fourDigitSquares.length * fourDigitPentagonals.length * fourDigitHexagonals.length * fourDigitHeptagonals.length * fourDigitOctagonals.length);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto isFigurateInit(ref bool[ulong] figurateTable) {
  bool isFigurate(ulong number) {
    return number in figurateTable ? true : false;
  }
  return &isFigurate;
}
