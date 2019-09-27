#!/usr/bin/env rdmd

import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;

void main() {
  StopWatch timer;
  ulong num = 0;
  ulong largestPal = 0;

  timer.start();
  foreach (ulong i; 100..1000) {
    foreach (ulong j; 100..1000) {
      num = i * j;
      if (num.isPalindrome() && num > largestPal)
        largestPal = num;
    }
  }
  timer.stop();

  largestPal.writeln();
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

bool isPalindrome(ulong num) {
  string bleh = num.to!(string);

  if (bleh == bleh.dup.reverse)
    return true;
  else
    return false;
}
