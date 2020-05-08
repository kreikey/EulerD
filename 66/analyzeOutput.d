#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.format;
import std.typecons;
import kreikey.intmath;

void main() {
  ulong x;
  ulong d;
  ulong y;
  Tuple!(ulong, ulong, ulong)[] result;

  foreach (l; File("output.txt").byLine()) {
    l.formattedRead("%d^2 - %d*%d^2 = 1", x, d, y);
    result ~= tuple(x, d, y);
  }
  
  result.sort!((a, b) => a[1] < b[1])();

  //printOriginalWithOffsets(result);
  printPrimeFactors(result);
}

void printPrimeFactors(Tuple!(ulong, ulong, ulong)[] result) {
  result.each!(a => writefln("x: %s, d: %s, largest prime factor of d: %s", a[0], a[1], primeFactors(a[1])[$-1]))();
}

void printOriginalWithOffsets(Tuple!(ulong, ulong, ulong)[] result) {
  auto result2 = result.map!(a => a[0], a => primeFactors(a[1])[$-1]).array();
  char op;

  foreach (original, pair; lockstep(result, result2)) {
    if ((pair[0] + 1) % pair[1] == 0)
      op = '+';
    else if ((pair[0] - 1) % pair[1] == 0)
      op = '-';
    writefln("%d^2 - %d*%d^2 = 1 %s", original.expand, op);
    //writeln((pair[0] + 1) % pair[1] == 0 || (pair[0] - 1) % pair[1] == 0);
  }
  writeln();
}
