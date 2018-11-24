#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.array;
import std.algorithm;
import Shared.bigInt;

void main(string args[]) {
  StopWatch sw;
  int[][] longNumbers;
  int[] accumulator;

  sw.start();
  File inFile = File("longNumbers.txt", "r");
  longNumbers = inFile.byLine.map!(line => line.reverse.map!(dig => cast(int)(dig - '0')).array()).array();
  accumulator = longNumbers[0].dup;

  foreach (line; longNumbers[1..$])
    accumulate(line, accumulator, 0);

  accumulator.reverse();
  writeln("The first 10 digits of the sum is: ", accumulator[0..10].map!(dig => cast(char)(dig + '0')).array());
  sw.stop();
  writeln("finished in ", sw.peek.msecs(), " milliseconds");
}
