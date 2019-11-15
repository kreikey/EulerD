#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import std.array;
import std.range;
import kreikey.intmath;

alias nthPermutation = kreikey.intmath.nthPermutation;

void main(string[] args) {
  StopWatch timer;
  int[] digits;
  ulong permCount = 1000000;
  //ulong permCount = 3628800;

  if (args.length > 1) {
    permCount = args[1].parse!ulong();
  }

  timer.start();
  digits = iota(10).array();

  digits.nthPermutation(permCount - 1);

  timer.stop();
  writefln("The %sth permutation of digits 0 - 9 is: %s", permCount, digits.map!(a => cast(char)(a + '0'))());
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

