#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;
  string[] longNumbers;
  BigInt accumulator;

  timer.start();
  File inFile = File("longNumbers.txt", "r");
  longNumbers = inFile.byLineCopy.array();
  accumulator = BigInt(longNumbers[0]);

  foreach (line; longNumbers[1 .. $]) {
    accumulator += BigInt(line);
  }

  writeln("The first 10 digits of the sum is: ", accumulator.digitString[0 .. 10]);
  writeln("total sum: ", accumulator);
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
