#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import kreikey.intmath;

void main() {
  StopWatch timer;

  auto triangulars = sequence!((a, n) => n * (n + 1) / 2);
  auto squares = sequence!((a, n) => n * n);
  auto pentagonals = sequence!((a, n) => n * (3 * n - 1) / 2);
  auto hexagonals = sequence!((a, n) => n * (2 * n - 1));
  auto heptagonals = sequence!((a, n) => n * (5 * n - 3) / 2);
  auto octagonals = sequence!((a, n) => n * (3 * n - 2));

  //auto triangulars = recurrence!((a, n) => a[n-1] + n + 1)(1);
  //auto squares = recurrence!((a, n) => a[n-1] + 2*n + 1)(1);
  //auto pentagonals = recurrence!((a, n) => a[n-1] + 3*n + 1)(1);
  //auto hexagonals = recurrence!((a, n) => a[n-1] + 4*n + 1)(1);
  //auto heptagonals = recurrence!((a, n) => a[n-1] + 5*n + 1)(1);
  //auto octagonals = recurrence!((a, n) => a[n-1] + 6*n + 1)(1);

  auto fourDigitTriangulars = triangulars.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitSquares = squares.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitPentagonals = pentagonals.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHexagonals = hexagonals.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitHeptagonals = heptagonals.find!(a => a > 999).until!(a => a >= 10000).array();
  auto fourDigitOctagonals = octagonals.find!(a => a > 999).until!(a => a >= 10000).array();

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
