#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import kreikey.intmath;
import kreikey.primes;

typeof(isPrimeInit()) isPrime;

static this() {
  isPrime = isPrimeInit();
}

void main() {
  StopWatch timer;

  timer.start();
  writeln("Finding non-prime numbers without repeated prime factors below 10,000,000");

  auto myFile = File("numbers.txt", "w");

  for (ulong n = 2; n < 10000000; n++) {
    if (n % 100000 == 0)
      writeln(n / 100000, "%");
    if (isPrime(n))
      continue;
    if (n.primeFactors.group.any!(a => a[1] != 1))
      continue;
    myFile.writeln(n);
    //writeln(n);
  }

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
