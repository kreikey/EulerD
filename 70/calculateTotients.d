#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import kreikey.intmath;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Calculating all totients for numbers in \"numbers.txt\"");

  auto inputFile = File("numbers.txt", "r");
  auto numbers = inputFile
    .byLine
    .map!(to!ulong)
    .array();

  auto outputFile = File("totients.txt", "w");

  foreach (n; numbers) {
    totient = getTotient(n);
    outputFile.writeln(n, " ", totient);
  }

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
