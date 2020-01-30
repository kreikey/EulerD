#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.traits;
import kreikey.digits;
import kreikey.bigint;

void main() {
  StopWatch timer;
  writeln("Lychrel Numbers");
  timer.start();
  iota(BigInt(1), 10000)
    .count!isLychrel
    .writeln();
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool isLychrel(BigInt number) {
  static bool[BigInt] cache;
  bool* result = number in cache;

  if (result != null)
    return *result;

  BigInt copy = number;
  BigInt rnum = number.reverse();
  
  foreach (i; 0..50) {
    number += number.reverse();
    if (number.isPalindrome()) {
      cache[copy] = false;
      cache[rnum] = false;
      return false;
    }
  }

  cache[copy] = true;
  cache[rnum] = true;
  return true;
}

