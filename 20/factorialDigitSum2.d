#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.bigint;

void main(string[] args) {
  StopWatch sw;
  int digits = 100;
  int sum;

  if (args.length > 1) {
    digits = args[1].to!int();
  }

  sw.start();

  BigInt result = digits;

  foreach (n; iota(2, digits).retro()) {
    result *= n;
  }

  sum = result.digitBytes.sum();

  sw.stop();

  writefln("The factorial of %s is:\n%s", digits, result);
  writefln("the sum of the digits is %s", sum);
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

