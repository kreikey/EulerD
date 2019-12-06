#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;
import std.traits;
import std.functional;

typeof(isPrimeInit()) isPrime;
//bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;
  bool compSum = false;
  ulong number = 0;

  timer.start();
  writeln("Goldbach's Other Conjecture");
  auto primes = new Primes!ulong();
  auto twiceSquares = sequence!((a, n) => 2 * n ^^ 2)().dropOne();
  auto odds = recurrence!((a, n) => a[n-1] + 2)(9uL);

  odds
    .cache
    .filter!(not!isPrime)
    .cache
    .map!(a => a, a => twiceSquares.until!(b => b >= a)
        .map!(b => primes.save.until!(c => c >= a)
          .map!(c => b + c)).join.canFind(a))
    .find!(a => !a[1])
    .front[0]
    .writeln();

  timer.stop();
  //writefln("The first number that fails Goldbach's other conjecture: %s", number);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
