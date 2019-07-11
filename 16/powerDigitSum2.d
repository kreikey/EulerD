#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import kreikey.bigint;

void main(string[] args) {
  int[] digits;
  int sum, pow = 1000;

  if (args.length > 1) {
    pow = args[1].to!int;
  }
  
  StopWatch sw;
  sw.start();

  BigInt num = 2;
  BigInt result = num ^^ pow;

  sum = result.digits.map!(d => d - '0').sum();

  sw.stop();
  writefln("2^%s = %s", pow, result);
  writefln("the sum of the digits is %s", sum);
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}
