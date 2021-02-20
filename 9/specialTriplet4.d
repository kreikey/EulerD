#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;
import kreikey.intmath;

void main(string[] args) {
  ulong a;
  ulong b;
  ulong c;
  ulong p = 1000;
  ulong divisor;
  ulong dividend;

  if (args.length > 1) {
    p = parse!ulong(args[1]);
  }

  StopWatch timer;

  timer.start();
  writeln("special pythagorean triplet");

  if (p % 2 != 0) {
    writeln("The perimeter must be even!");
    return;
  }

  auto triples = getPythagoreanTriples(p);

  if (triples.length > 0) {
    a = triples[0][0];
    b = triples[0][1];
    c = triples[0][2];
    writefln("%s^2 + %s^2 = %s^2", a, b, c);
    writefln("%s * %s * %s = %s", a, b, c, a * b * c);
  } else {
    writeln("no pythagorean triplet found");
  }

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
