#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import kreikey.intmath;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;

void main() {
  StopWatch timer;

  timer.start();

  writeln("Counting 10-digit pandigital permutations");

  auto pandigital = iota(10u).array();
  auto perms = permutations(pandigital);

  auto number = perms
    //.map!toNumber
    //.tee!writeln
    .count();

  timer.stop();

  writefln("There are %s 10-digit pandigital permutations.", number);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
