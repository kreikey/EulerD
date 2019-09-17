#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import kreikey.bytemath;

void main(string[] args) {
  StopWatch timer;
  byte[] digits = [2];
  int sum = 0;
  int pow = 1000;

  if (args.length > 1) {
    pow = args[1].parse!int();
  }

  timer.start();

  foreach (i; 1 .. pow) {
    digits = digits.mul([2]);
  }

  sum = digits.sum();

  timer.stop();
  writefln("2^%s = %s", pow, digits.rstr);
  writefln("the sum of the digits is %s", sum);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
