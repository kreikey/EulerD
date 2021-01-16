#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.intmath;

void main() {
  iota(1u, 101u)
    .map!(a => a.recipDigits!ubyte(10))
    .each!writeln();
}
