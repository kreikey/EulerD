#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.bytemath;

void main(string[] args) {
  StopWatch timer;
  ubyte[] result;
  ubyte[] addend1;
  ubyte[] addend2;
  int limit = 1000;
  int term = 2;

  if (args.length > 1) {
    limit = args[1].parse!int();
  }

  timer.start();
  addend1 = "1".rbytes();
  addend2 = "1".rbytes();

  while (result.length < limit) {
    result = add(addend1, addend2);
    addend1 = addend2;
    addend2 = result;
    term++;
  }
  timer.stop();

  writefln("the first %s-digit fibonacci term is number %s.", limit, term);
  writefln("the term is:\n%s", result.rstr);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

