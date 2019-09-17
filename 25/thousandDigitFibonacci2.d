#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import std.conv;
import std.range;
import kreikey.bigint;

void main(string[] args) {
  StopWatch timer;
  int limit = 1000;

  if (args.length > 1)
    limit = args[1].parse!int();

  timer.start();

  BigInt a = 1;
  BigInt b = 1;
  BigInt temp;
  int index = 2;

  while (b.digitBytes.length < limit) {
    temp = b;
    b = b + a;
    a = temp;
    index++;
  }

  timer.stop();

  writefln("the index of the first %s-digit fibonacci term is %s.", limit, index);
  writefln("the term is:\n%s", b);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
