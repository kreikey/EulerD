#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;

void main(string[] args) {
  ulong a = 0;
  ulong b = 0;
  ulong c = 0;
  ulong pmax = 1000;
  ulong csq = 0;
  ulong absq = 0;
  ulong p = 0;
  ulong pmost = 0;
  enum real pdiv = sqrt(real(2)) + 1;
  alias Triplet = Tuple!(ulong, ulong, ulong);
  Triplet[] triplets = [];
  Triplet[] mostTriplets = [];

  if (args.length > 1) {
    pmax = parse!ulong(args[1]);
  }

  StopWatch timer;

  timer.start();
  writeln("integer right triangles");

  for (p = 4; p <= pmax; p += 2) {
    c = ceil(p / pdiv).to!ulong();
    b = ceil(real(p - c) / 2).to!ulong();
    a = p - c - b;
    csq = c ^^ 2;

    do {
      absq = a ^^ 2 + b ^^ 2;
      if (absq == csq) {
        triplets ~= tuple(a, b, c);
      } else if (absq > csq) {
        c++;
        a--;
        csq = c ^^ 2;
      }
      b++;
      a--;
    } while (a > 0);

    if (triplets.length > mostTriplets.length) {
      mostTriplets = triplets;
      pmost = p;
    }

    triplets = [];
  }

  writefln("A perimeter of %s yields the most integer right triangles. Its triangles are:", pmost);
  mostTriplets.each!(a => writefln("%(A: %s\tB: %s\tC: %s%)", a))();

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
