#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.array;
import kreikey.primes;
import kreikey.intmath;
import std.functional;

alias primeFactors = memoize!(getPrimeFactors!ulong);

void main () {
  StopWatch timer;
  auto p = new Primes!long();
  ulong num = 600851475143;


  timer.start();

  writeln(num.primeFactors.reduce!(max));

  timer.stop();

  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
