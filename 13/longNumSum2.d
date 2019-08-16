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
  //accumulator = longNumbers[0].dup;
  accumulator = BigInt(longNumbers[0]);

  foreach (line; longNumbers[1..$])
    //accumulate(line, accumulator, 0);
    accumulator += BigInt(line);

  //accumulator.reverse();
  writeln("The first 10 digits of the sum is: ", accumulator.digitString[0 .. 10]);
  writeln("total sum: ", accumulator);
  sw.stop();
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
