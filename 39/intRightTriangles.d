#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;
import std.typecons;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong pmax = 1000;
  ulong p = 0;
  ulong pmost = 0;
  alias Triplet = Tuple!(ulong, ulong, ulong);
  Triplet[] triplets = [];

  if (args.length > 1) {
    pmax = parse!ulong(args[1]);
  }

  timer.start();
  writeln("integer right triangles");

  auto result = iota!ulong(4, pmax + 1, 2)
    .map!(a => a, getPythagoreanTriples)
    .map!(a => a[1].length, a => a[0], a => a[1])
    .fold!max();

  triplets = result[2];
  pmost = result[1];

  writefln("For all perimeters P <= %s, P = %s yields the most integer right triangles.", pmax, pmost);
  writeln("Its triangles are: ");
  triplets.each!(a => writefln("%(A: %s\tB: %s\tC: %s%)", a))();

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}

/*
auto getPythagoreanTriples(T)(T perimeter) if (isIntegral!T) {
  assert (perimeter > 0);

  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[] triples = [];
  T c = ceil(perimeter / pdiv).to!T();
  T b = ceil(real(perimeter - c) / 2).to!T();
  T a = perimeter - c - b;
  T csq = c ^^ 2;
  T absq = a ^^ 2 + b ^^ 2;

  do {
    if (absq == csq) {
      triples ~= tuple(a, b, c);
    } else if (absq > csq) {
      c++;
      a--;
      csq = c ^^ 2;
    }
    b++;
    a--;
    absq = a ^^ 2 + b ^^ 2;
  } while (a > 0 && a < T.max);

  return triples;
}
*/
