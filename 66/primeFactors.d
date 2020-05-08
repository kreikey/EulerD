#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import kreikey.intmath;

alias primeFactors = kreikey.intmath.primeFactors;
void main() {
  writeln("277631049 ", primeFactors(277631049));
  writeln("701 ", primeFactors(701));
  writeln("10485980 ", primeFactors(10485980));
  writeln("1728148040 ", primeFactors(1728148040));
  writeln("151 ", primeFactors(151));
  writeln("140634693 ", primeFactors(140634693));
}
