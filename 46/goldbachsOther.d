#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;
import std.traits;

typeof(isPrimeInit()) isPrime;
//bool delegate(ulong) isPrime;

static this() {
  isPrime = isPrimeInit();
}

ulong max = short.max;

void main() {
  StopWatch timer;
  bool compSum = false;
  ulong number = 0;

  timer.start();
  writeln("Goldbach's Other Conjecture");
  number = findNonGoldbachNumber();

  if (number != 0) {
    writeln("Found number that's not the sum of twice a square and a prime!");
    writefln("The first number that fails Goldbach's other conjecture: %s", number);
  } else {
    writefln("Found no number below %s that fails Goldbach's other conjecture.", max);
  }
    
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong findNonGoldbachNumber() {
  for (ulong n = 9; n < max; n += 2) {
    if (n.isPrime())
      continue;

    if (!isGoldbachNumber(n))
      return n;
  }

  return 0;
}

bool isGoldbachNumber(ulong number) {
  auto twiceSquares = sequence!((a, n) => 2 * n ^^ 2)().dropOne();
  auto primes = new Primes!ulong();

  foreach (p; primes.save.until!((a, n) => a >= n)(number))
    foreach (s; twiceSquares.until!((a, n) => a >= n)(number))
      if (p + s == number)
        return true;

  return false;
}
