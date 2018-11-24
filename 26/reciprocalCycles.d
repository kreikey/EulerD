#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime;
import std.algorithm;
import std.conv;
//import reciprocals;
import reciprocals2;

import std.range;

void main(string[] args) {
  StopWatch sw;
  ulong end = 999;
  ulong start = 1;

  if (args.length > 1)
    end = args[1].parse!(ulong);

  sw.start();

  //foreach (i; 0 .. 100) {
  auto recs = Reciprocals();
  auto rec = recs[start .. end].reduce!((a, b) => a.reptend.length > b.reptend.length ? a : b);

  writefln("the reciprocal of the numbers between:\n%s and %s\nwith the longest reptend is: %s", start + 1, end + 1, rec);
  writefln("denominator: %s", rec.denominator);
  writefln("transient: %s\ntransient length: %s", rec.transient, rec.transient.length);
  writefln("reptend: %s\nreptend length: %s", rec.reptend, rec.reptend.length);
  writeln();
  //}

  //Reciprocal rec2 = Reciprocal(363);

  //writefln("some reciprocal: %s", rec2);
  //writefln("denominator: %s", rec2.denominator);
  //writefln("transient: %s\ntransient length: %s", rec2.transient, rec2.transient.length);
  //writefln("reptend: %s\nreptend length: %s", rec2.reptend, rec2.reptend.length);
  //writeln();

  //rec2 = Reciprocal(682);
  //writefln("some reciprocal: %s", rec2);
  //writefln("denominator: %s", rec2.denominator);
  //writefln("transient: %s\ntransient length: %s", rec2.transient, rec2.transient.length);
  //writefln("reptend: %s\nreptend length: %s", rec2.reptend, rec2.reptend.length);

  writeln("finished in ", sw.peek.msecs(), " milliseconds");
}
