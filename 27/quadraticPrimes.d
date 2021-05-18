#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.conv;
import std.math;
import kreikey.primes;
import kreikey.intmath;

bool delegate(int) isPrime;
Primes!int pns;

static this() {
  pns = new Primes!int();
  isPrime = isPrimeInit!int();
}

void main() {
  StopWatch timer;

  writeln("Quadratic primes");

  timer.start();

  int[] as = iota(-999, 1000, 2).array();
  int[] bs = pns.until!(x => x > 1000).array();
  int[] mostPrimes;
  int[] primes;
  int[2] polyMostPrimes;

  writefln("There are %d polynomials to test", as.length * bs.length);
  writeln("Testing polynomials...");

  foreach(a; as) {
    foreach(b; bs) {
      primes = generatePrimes(a, b);

      if (primes.length > mostPrimes.length) {
        mostPrimes = primes;
        polyMostPrimes = [a, b];
      }
    }
  }

  timer.stop();

  writeln("The polynomial that generates the most primes is: ");
  writefln("n^2 + %dn + %d", polyMostPrimes[0], polyMostPrimes[1]);
  writeln("The primes: ", mostPrimes);
  writeln("The number of primes: ", mostPrimes.length);
  writeln("The product of the coefficients: ", polyMostPrimes[0] * polyMostPrimes[1]);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

int[] generatePrimes(int a, int b) {
  int n = 0;
  int[] result;
  int cur;

  cur = eulerPrimeGen(a, b, n);

  while (isPrime(cur)) {
    result ~= cur;
    n++;
    cur = eulerPrimeGen(a, b, n);
  }

  return result;
}

int eulerPrimeGen(int a, int b, int n) {
  return n ^^ 2 + a * n + b;
}

