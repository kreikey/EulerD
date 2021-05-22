#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import std.conv;
import kreikey.digits;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;

  timer.start();

  auto longNumbers = File("longNumbers.txt", "r")
    .byLine
    .map!toDigits
    .array();
  
  ulong width = longNumbers[0].length;
  ulong height = longNumbers.length;
  ulong part = 0;
  ulong sum = 0;
  uint[] sumdigs = [];
  auto maxParts = getMaxParts(height);
  ulong index = 0;

  foreach (i; 0..width) {
    part = 0;

    foreach (j; 0..height)
      part += longNumbers[j][i];

    sum += part;
    sumdigs = sum.toDigits();

    index = (width - i) > maxParts.length ? 0 : maxParts.length - (width - i);
    if (sumdigs.length > 9 && sumdigs[0..10] == (sum + maxParts[index]).toDigits()[0..10])
      break;

    if (i != width-1)
      sum *= 10;
  }

  writeln("The first 10 digits of the sum is: ", sumdigs[0..10].toString());
  //5537376230
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

ulong[] getMaxParts(ulong height) {
  double[] maxcols;
  double colmax = 9 * height;
  ulong[] result;

  do {
    colmax /= 10;
    maxcols ~= colmax;
  } while (colmax.to!ulong() > 0);

  foreach (i, r; maxcols)
    result ~= maxcols[0..$-i].sum.to!ulong();

  result ~= 0;

  return result;
}
