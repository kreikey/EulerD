#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import kreikey.combinatorics;

alias permutations = kreikey.combinatorics.permutations;

void main() {
  auto digits = iota(1, 5).array();
  auto digits2 = iota(5, 10).array();

  digits
    .permutations
    .group
    .each!((a, b) => writeln(a, " ", b));
}
