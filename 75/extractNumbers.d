#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.traits;
import std.typecons;
import std.math;
import std.conv;
import std.format;
import kreikey.intmath;
import kreikey.util;

void main() {
  int a, b, c, p;
  bool notMultiple;
  Tuple!(int, int, int, int)[] triangles;
  int[][] factorsMatrix;
  auto outFile = File("someNumbers3.txt", "w+");

  foreach (l; File("triangles.txt").byLine.take(1001)) {
    l.formattedRead!"%d^2 + %d^2 = %d^2 p = %s"(a, b, c, p);
    notMultiple = only(a, b).fold!gcd() == 1;
    factorsMatrix = only(a, b, c).map!getDistinctPrimeFactors.array();

    if (notMultiple)
      outFile.writeln(a, " ", b, " ", c, " ", factorsMatrix); 
  }
}
