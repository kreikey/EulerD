#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.algorithm;
import kreikey.figurates;

void main() {
  auto pentagonals = Pentagonals(1);

  pentagonals.take(100).each!(a => write(a, " "))();
  writeln();
  //pentagonals.take(200).slide(2).map!sum.each!(a => write(a, " "))();
  //writeln();
  //pentagonals.slide(2).map!sum.filter!isPentagonal.each!writeln();
}
