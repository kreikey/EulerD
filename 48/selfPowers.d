#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.datetime.stopwatch;
import kreikey.bigint;

void main() {
  StopWatch timer;
  BigInt sum = 0;
  byte[] zeros = repeat!byte(0, 10).array();
  //auto someBytes = iota!ubyte(0, 10).array();
  //writeln(zeros);
  //writeln(someBytes);
  timer.start();
  writeln("Self powers");
  writeln("Please wait for about two minutes.");

  foreach (n; 1..1001) {
    if (n % 10 == 0)
      continue;

    sum += BigInt(n)^^n;
  }

  timer.stop();
  writefln("The last 10 digits of the sum of self-powers n^n from 1 through 1000 are:\n%s", sum.digitString[$-10..$]);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
