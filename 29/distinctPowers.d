#!/usr/bin/env rdmd -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import kreikey.bigint;

void main(string[] args) {
  StopWatch sw;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  BigInt[][] powersMatrix;
  BigInt[] row;
  BigInt res;

  sw.start();

  foreach(base; 2 .. n + 1) {
    row = [];
    foreach(exponent; 2 .. n + 1) {
      res = BigInt(base) ^^ BigInt(exponent);
      row ~= res;
    }
    powersMatrix ~= row;
  }

  powersMatrix.multiwayUnion.count.writeln();

  sw.stop();
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}
