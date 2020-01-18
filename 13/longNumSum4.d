#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import kreikey.bytemath;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;

  timer.start();

  auto longNumbers = File("longNumbers.txt", "r")
    .byLine
    .map!(l => l.map!(d => d - '0').array())
    .array();
  
  ulong width = longNumbers[0].length;
  ulong height = longNumbers.length;
  ulong part = 0;
  ulong sum = 0;
  ulong colmax = 9 * height / 10;
  ulong addmax = 0;
  ulong digsmin = 0;
  ulong digsrem = 0;
  uint[] sumdigs;

  do {
    addmax += colmax;
    digsmin++;
    colmax /= 10;
  } while (colmax > 0);

  foreach (i; 0..width) {
    digsrem = height - 1 - i;
    part = 0;

    foreach (j; 0..height)
      part += longNumbers[j][i];

    sum += part;
    sumdigs = sum.toDigits();

    foreach (j; digsrem..digsmin)
      addmax /= 10;
    foreach (j; digsrem..digsmin)
      addmax *= 10;

    if (sumdigs.length > 9 && sumdigs[0..10] == (sum+addmax).toDigits()[0..10])
      break;

    if (i != width-1)
      sum *= 10;
  }

  writeln("The first 10 digits of the sum is: ", sumdigs[0..10].toString());
  //5537376230
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
