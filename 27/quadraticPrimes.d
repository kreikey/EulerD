#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime;
import std.algorithm;
import std.range;
import std.conv;
import std.math;
import kreikey.primes;
//import kreikey.intmath;

bool delegate(int) isPrime;

void main(string[] args) {
  StopWatch sw;

  sw.start();

  isPrime = isPrimeInit();
  int[] as = iota(-999, 1000, 2).array();
  auto pns = new Primes!int();
  int[] bs = pns.until!(x => x > 1000).array();
  int[] mostPrimes;
  int[] primes;
  int[2] polyMostPrimes;

  writefln("There are %d polynomials to test", as.length * bs.length);
  writeln("Testing polynomials...");

  foreach(a; as) {
    foreach(b; bs) {
      primes = generatePrimes(a, b);
      //writefln("n^2 + %dn + %d", a, b);

      if (primes.length > mostPrimes.length) {
        mostPrimes = primes;
        polyMostPrimes = [a, b];
        writefln("n^2 + %dn + %d", a, b);
        writeln(primes);
      }
    }
  }

  writeln(mostPrimes.length);
  sw.stop();

  writeln("The polynomial that generates the most primes is: ");
  writefln("n^2 + %dn + %d", polyMostPrimes[0], polyMostPrimes[1]);
  writeln("The primes: ", mostPrimes);
  writeln("The number of primes: ", mostPrimes.length);
  writeln("The product of the coefficients: ", polyMostPrimes[0] * polyMostPrimes[1]);
  writeln("finished in ", sw.peek.msecs(), " milliseconds.");
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

bool delegate(int) isPrimeInit() {
  auto p = new Primes!int();
  int[int] savedPrimes;
  int pndx;
  //int[] savedPrimes;
  savedPrimes[p.front] = pndx++;
  //savedPrimes ~= p.front;

  bool isPrime(int number) {
    if (number < 2)
      return false;

    if (number > p.front) {
      foreach(z; p.until!(x => x >= number)(No.openRight)) {
        savedPrimes[z] = pndx++;
        //savedPrimes ~= z;
      }
    }

    if ((number in savedPrimes) !is null)
    //if (savedPrimes.canFind(number))
      return true;
    else
      return false;
  }

  return &isPrime;
}

