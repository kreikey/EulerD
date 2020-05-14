#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import std.conv;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;

void main() {
  StopWatch timer;
  string[] ringStrings;
  string maxRing;
  ulong preferredLength;

  timer.start();
  auto ringSource = iota(1, 11).array();

  writeln("finding rings...");

  ringStrings = ringSource
    .permutations
    .filter!(a => a.front == a[0..$/2].fold!min())
    .map!describe
    .filter!(a => a[1..$].all!(b => b.sum() == a[0].sum()))
    .map!concatenate
    .array();

  ringStrings.each!writeln();
  preferredLength = ringStrings.map!(a => a.length).fold!min();
  maxRing = ringStrings
    .filter!(a => a.length == preferredLength)
    .fold!max();
  writefln("the max ring of length %s is %s", preferredLength, maxRing);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

int[][] describe(int[] ring) {
  int[][] description;
  auto halfLen = ring.length / 2;
  auto outer = ring[0..halfLen];
  auto inner = ring[halfLen..$].cycle();

  foreach (i; 0..outer.length)
    description ~= [outer[i], inner[i], inner[i+1]];

  return description;
}

string concatenate(int[][] ringDesc) {
  return ringDesc
    .map!(piece => piece
        .map!(to!string)
        .join())
    .join();
}
