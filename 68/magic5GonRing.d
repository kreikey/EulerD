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
  ulong permCount = 0;
  ulong commonSum = 0;
  ulong ringSum = 0;
  int[][] desc;
  string[] ringStrings;
  string maxRing;
  ulong preferredLength;

  timer.start();
  auto ringSource = iota(1, 11).array();
  auto halfLen = ringSource.length / 2;
  auto outer = ringSource[0..halfLen];
  auto inner = ringSource[halfLen..$].cycle();

  writeln("finding rings...");

  foreach (ring; ringSource.permutations()) {
    if (ring[0] != ring[0..halfLen].fold!min())
      continue;
    if (!ringIsValid(ring))
      continue;
    ringStrings ~= ring.describe.concatenate();
    permCount++;
  }

  writefln("rings found: %s", permCount);
  ringStrings.each!writeln();
  preferredLength = ringStrings.map!(a => a.length).fold!min();
  maxRing = ringStrings
    .filter!(a => a.length == preferredLength)
    .fold!max();
  writefln("the max ring of length %s is %s", preferredLength, maxRing);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

bool ringIsValid(int[] ring) {
  auto halfLen = ring.length / 2;
  auto outer = ring[0..halfLen];
  auto inner = ring[halfLen..$].cycle();
  ulong ringSum = 0;
  ulong commonSum = outer[0] + inner[0] + inner[1];

  foreach (i; 1..outer.length) {
    ringSum = outer[i] + inner[i] + inner[i+1];
    if (ringSum != commonSum)
      return false;
  }
  return true;
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
