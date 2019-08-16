#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import kreikey.bytemath;

void main(string[] args) {
  StopWatch sw;
  byte[][] longNumbers;
  byte[] accumulator;

  sw.start();
  File inFile = File("longNumbers.txt", "r");
  longNumbers = inFile.byLine.map!(line => line.reverse.map!(dig => cast(byte)(dig - '0')).array()).array();
  accumulator = longNumbers[0].dup;

  foreach (line; longNumbers[1..$])
    accumulate(line, accumulator);

  accumulator.reverse();
  writeln("The first 10 digits of the sum is: ", accumulator[0..10].map!(dig => cast(char)(dig + '0')).array());
  sw.stop();
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
