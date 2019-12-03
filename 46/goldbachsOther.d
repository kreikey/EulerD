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

void main() {
  StopWatch timer;
  bool compSum = false;
  ulong number = 0;

  timer.start();
  writeln("Goldbach's Other Conjecture");
  auto primes = new Primes!ulong();
  auto twiceSquares = sequence!((a, n) => 2 * n ^^ 2)().dropOne();

  for (ulong n = 9; n > 1; n += 2) {
    //writeln(n, ":");
    compSum = false;
    if (n.isPrime())
      continue;

    foreach (p; primes.save.until!(a => a > n)) {
      //writeln("\t", p);
      foreach (s; twiceSquares.until!(a => a > n)) {
        //writeln("\t\t", s);
        if (p + s == n) {
          compSum = true;
          break;
        }
      }
      if (compSum)
        break;
    }

    if (!compSum) {
      writeln("Found number that's not the sum of twice a square and a prime!");
      number = n;
      break;
    }

  }

  timer.stop();
  writefln("Non-Goldbach number: %s", number);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
