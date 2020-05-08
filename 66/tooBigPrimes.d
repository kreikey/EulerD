#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.traits;
import kreikey.intmath;

typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  File("tooBigD.txt")
    .byLine
    .map!(to!int)
    .map!(a => a, isPrime)
    .each!(a => writefln("%s %s", a[0], (a[1] ? "prime" : "not prime")))();
}
