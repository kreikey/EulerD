#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import std.format;
import std.array;
import std.range;
import kreikey.intmath;
import kreikey.digits;

alias isPalindrome = digits => digits == digits.dup.reverse();

void main(string[] args) {
  StopWatch timer;
  ulong limit = 1_000_000;

  if (args.length > 1)
    limit = args[1].parse!ulong();

  writeln("double-base palindromes");
  timer.start();

  auto palindromes = palindromesInit.generate();
  auto sum = palindromes.until!(a => a >= limit)
    .map!(a => a, toDigits!2)
    .filter!(a => a[1].isPalindrome())
    .tee!(a => writeln(a[0], "\t", a[1].toString()))
    .map!(a => a[0])
    .sum();

  timer.stop();

  writefln("The sum of numbers less than %d, that are palindromic in base 10 and 2, is:\n%d", limit, sum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

auto palindromesInit() {
  ulong palindromeLength = 1;
  ulong sourceLength = palindromeLength / 2 + palindromeLength % 2;
  ulong sourceMin = 10 ^^ (sourceLength - 1);
  ulong sourceMax = 10 ^^ sourceLength - 1;
  ulong source = 0;

  auto palindromes() {
    if (source > sourceMax) {
      palindromeLength++;
      sourceLength = palindromeLength / 2 + palindromeLength % 2;
      sourceMin = 10 ^^ (sourceLength - 1);
      sourceMax = 10 ^^ sourceLength - 1;
      source = sourceMin;
    }

    auto digits = source.toDigits();
    auto rightHalf = digits[0..palindromeLength/2].dup;
    reverse(rightHalf);
    auto palindrome = digits ~ rightHalf;
    source++;

    return palindrome.toNumber();
  }

  return &palindromes;
}
