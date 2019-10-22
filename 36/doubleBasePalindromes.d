#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import std.format;
import std.array;
import std.range;
import kreikey.intmath;

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1_000_000;

  writeln("double-base palindromes");
  timer.start();

  if (args.length > 1)
    limit = args[1].parse!ulong();

  auto sum = iota!ulong(0, limit)
    .map!(a => a, a => a.to!string(), a => format("%b", a))
    .filter!(a => a[1].isPalindrome() && a[2].isPalindrome())
    .tee!(a => writeln(a[1], "\t", a[2]))
    .map!(a => a[0])
    .sum();

  timer.stop();

  writefln("The sum of numbers less than %d, that are palindromic in base 10 and 2, is:\n%d", limit, sum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

bool isPalindrome(string num) {
  return num == num.dup.reverse;
}
