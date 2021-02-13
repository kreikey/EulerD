#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime;
import std.typecons;
import kreikey.intmath;

void main() {
  auto triplets = iota!ulong(3, 1500001)
    .map!(a => zip(a.getTriplets(), repeat(a)))
    .joiner
    .map!(a => tuple(a[0][0], a[0][1], a[0][2], a[1]))
    .each!(a => writefln("%(%s %s %s %s%)", a))();
}
