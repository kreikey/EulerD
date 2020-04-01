#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import kreikey.primes;
import kreikey.digits;

void main(string[] args) {
  int n;
  auto primes = new Primes!ulong();

  if (args.length < 2) {
    writeln("Give an argument for the number of primes to print.");
    return;
  } else {
    n = args[1].to!int();
  }

  primes.take(n)
    .each!writeln();
}
