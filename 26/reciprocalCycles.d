#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import reciprocals2;

import std.range;

void main(string[] args) {
  StopWatch timer;
  ulong end = 1000;
  ulong start = 2;

  if (args.length > 1)
    end = args[1].parse!ulong();

  timer.start();

  auto recs = Reciprocals();
  auto rec = recs[start .. end].reduce!((a, b) => a.reptend.length > b.reptend.length ? a : b);

  writefln("the reciprocal of the numbers between:\n%s and %s\nwith the longest reptend is: %s", start, end, rec);
  writefln("denominator: %s", rec.denominator);
  writefln("transient: %s\ntransient length: %s", rec.transient, rec.transient.length);
  writefln("reptend: %s\nreptend length: %s", rec.reptend, rec.reptend.length);
  writeln();

  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
