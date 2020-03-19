#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;
import kreikey.combinatorics;
import kreikey.digits;
import kreikey.util;

alias isPermutation = kreikey.combinatorics.isPermutation;

void main() {
  StopWatch timer;
  Tuple!(uint[], ulong, ulong)[] cubeDigitList;
  ulong[uint[]] permCount;
  ulong base = 0;
  ulong number;
  uint[] sortedDigits;
  bool done = false;

  timer.start();
  writefln("Cubic permutations");

  do {
    base++;
    number = base ^^ 3;
    sortedDigits = number.toDigits.asort();
    cubeDigitList ~= tuple(sortedDigits, base, number);
    permCount[sortedDigits.idup]++;
  } while (permCount[sortedDigits] != 5);

  auto theDigits = cubeDigitList[$-1][0];
  auto idx = cubeDigitList.countUntil!(a => a[0] == theDigits);
  auto lowestBase = cubeDigitList[idx][1];
  auto highestBase = cubeDigitList[$-1][1];
  auto lowestCube = cubeDigitList[idx][2];
  auto highestCube = cubeDigitList[$-1][2];

  writefln("lowest: %s ^^ 3 = %s\thighest: %s ^^ 3 = %s", lowestBase, lowestCube, highestBase, highestCube);
  writeln("The smallest cube for which exactly five permutations of its digits are cube is:");
  writeln(lowestCube);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
