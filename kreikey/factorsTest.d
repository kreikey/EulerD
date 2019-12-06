#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import kreikey.intmath;

alias primeFactors = primeFactors1;

void main() {
  writeln(properDivisors(5487478));
  writeln(primeFactors(5487478));
}
