#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import kreikey.combinatorics;
import kreikey.intmath;

alias permutations = kreikey.combinatorics.permutations;

void main() {
  auto digits = iota(1, 5).array();
  auto digits2 = iota(1, 10).array();

  digits
    .permutations
    .array
    .asort
    .group
    .each!(a => writefln("%(%s\t%s%)", a));
}
