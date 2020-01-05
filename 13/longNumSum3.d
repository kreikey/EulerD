#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.algorithm;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;
  timer.start();

  auto sum = File("longNumbers.txt", "r")
    .byLineCopy
    .map!BigInt
    .sum();

  writeln("The first 10 digits of the sum is: ", sum.digitString[0 .. 10]);
  writeln("total sum: ", sum);
  timer.stop();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
