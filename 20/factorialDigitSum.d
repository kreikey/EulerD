#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import kreikey.bytemath;

void main(string[] args) {
  StopWatch timer;
  ubyte[] digits = "100".dup.rbytes();
  int offset = 0;
  int sum;

  if (args.length > 1) {
    digits = args[1].dup.rbytes();
  }

  timer.start();

  ubyte[] result = digits.dup;

  for (ubyte[] x = result.sub([1]); x.isGreaterThan([1]); x.decumulate([1])) {
    result = result.mul(x);
  }

  sum = result.sum();
  timer.stop();

  writefln("The factorial of %s is:\n%s", digits.rstr(), result.rstr());
  writefln("the sum of the digits is %s", sum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

