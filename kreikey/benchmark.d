#!/usr/bin/env rdmd -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;
  BigInt numerator = ulong.max.to!string();
  BigInt denominator = uint.max.to!string();
  BigInt quotient = 0;
  BigInt remainder = 0;

  timer.start();
  for (ulong i = 0; i < 100000; i++) {
    quotient = numerator / denominator;
    remainder = numerator % denominator;
    //writefln("numerator: %s\tdenominator: %s\tquotient: %s\tremainder: %s", numerator, denominator, quotient, remainder);
    numerator--;
  }
  for (ulong i = 0; i < 100000; i++) {
    quotient = numerator / denominator;
    remainder = numerator % denominator;
    //writefln("numerator: %s\tdenominator: %s\tquotient: %s\tremainder: %s", numerator, denominator, quotient, remainder);
    denominator++;
  }

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
