#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.array;
import std.conv;
import std.algorithm;
import kreikey.bigint;

void main(string args[]) {
  StopWatch sw;
  int[] result;
  int[] addend1;
  int[] addend2;
  int length = 1000;
  int term;

  if (args.length > 1) {
    length = args[1].parse!int;
  }

  sw.start();

  addend1 = "1".dup.toReverseIntArr;
  addend2 = "1".dup.toReverseIntArr;

  accumulate(result, addend1, 0);
  accumulate(result, addend2, 0);
  addend1 = result.dup;
  term = 3;

  while (result.length < length) {
    accumulate(result, addend2, 0);
    addend2 = addend1.dup;
    addend1 = result.dup;
    term++;
  }

  sw.stop();

  writefln("the first %s-digit fibonacci term is number %s.", length, term);
  writefln("the term is:\n%s", result.toReverseCharArr);
  writefln("finished in %s milliseconds", sw.peek.msecs());
}
