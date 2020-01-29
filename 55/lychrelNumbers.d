#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import kreikey.bytemath;
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
  foreach (i; 0..50) {
    number += number.digitBytes.reverse.BigInt();
    if (number.isPalindrome())
      return false;
  }
  return true;
}

bool isPalindrome(BigInt num) {
  byte[] digits = num.digitBytes();

  if (digits == digits.dup.reverse())
    return true;
  else
    return false;
}
