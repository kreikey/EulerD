#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import std.format;
import std.array;
import std.range;
import kreikey.intmath;

alias isPalindrome = digits => digits == digits.dup.reverse();

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1_000_000;

  if (args.length > 1)
    limit = args[1].parse!ulong();

  writeln("double-base palindromes");
  timer.start();

  auto sum = iota!ulong(0, limit)
    .map!(a => a, toDigits!10, toDigits!2)
    .filter!(a => a[1].isPalindrome() && a[2].isPalindrome())
    .tee!(a => writeln(a[1].toString(), "\t", a[2].toString()))
    .map!(a => a[0])
    .sum();

  timer.stop();

  writefln("The sum of numbers less than %d, that are palindromic in base 10 and 2, is:\n%d", limit, sum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

