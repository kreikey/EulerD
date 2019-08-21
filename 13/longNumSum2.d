#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import kreikey.bigint;

void main(string[] args) {
  StopWatch sw;
  string[] longNumbers;
  BigInt accumulator;

  sw.start();
  File inFile = File("longNumbers.txt", "r");
  longNumbers = inFile.byLineCopy.array();
  accumulator = BigInt(longNumbers[0]);
  //writeln(accumulator);

  foreach (line; longNumbers[1 .. $]) {
    accumulator += BigInt(line);
    //writeln(accumulator);
  }

  writeln("The first 10 digits of the sum is: ", accumulator.digitString[0 .. 10]);
  writeln("total sum: ", accumulator);
  sw.stop();
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
