#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime;
import std.typecons;
import kreikey.intmath;

void main() {
  auto triplets = iota!long(3, 1500001)
    .map!(a => a, countPythagoreanTriples)
    .filter!(a => a[1] > 0)
    .each!(a => writefln("%(%s %s%)", a))();
}
