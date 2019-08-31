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
  longNumbers = inFile.byLine.map!(rbytes).array();
  accumulator = longNumbers[0].dup;

  foreach (i, line; longNumbers[1 .. $]) {
    accumulate(accumulator, line);
  }

  writeln("The first 10 digits of the sum is: ", accumulator.rstr()[0..10]);
  writeln("total sum: ", accumulator.rstr());
  sw.stop();
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
