#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;

void main() {
  StopWatch timer;
  auto primes = new Primes!();

  timer.start();
  auto lenSum = primes
    .until!((a, n) => a >= n)(1000000uL)
    .map!(a => a.primeSumLength(), a => a)
    .tee!writeln
    .fold!max();
  timer.stop();

  writefln("The longest sum of consecutive primes below one-million contains :\n%s terms and is equal to:\n%s", lenSum[0], lenSum[1]);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong primeSumLength(ulong num) {
  auto primes = new Primes!();
  auto addPrimes = primes.until(num, OpenRight.no).array();
  auto subPrimes = addPrimes;
  ulong sum = 0;
  ulong count;

  do {
    //if (sum < num) {
    sum += addPrimes.front;
    addPrimes.popFront();
    count++;

    while (sum > num) {
      sum -= subPrimes.front;
      subPrimes.popFront();
      count--;
    }
  } while (sum != num);

  return count;
}
