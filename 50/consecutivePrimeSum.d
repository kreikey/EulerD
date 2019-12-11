#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.primes;
import std.typecons;

typeof(primeSumLengthInit()) primeSumLength;

static this() {
  primeSumLength = primeSumLengthInit();
}

void main() {
  StopWatch timer;
  auto primes = new Primes!();

  timer.start();
  auto lenSum = primes
    .until!((a, n) => a >= n)(1000000uL)
    .map!(a => a.primeSumLength(), a => a)
    .fold!max();
  timer.stop();

  writefln("The longest sum of consecutive primes below one-million contains :\n%s terms and is equal to:\n%s", lenSum[0], lenSum[1]);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong delegate(ulong) primeSumLengthInit() {
  auto primes = new Primes!();
  ulong[] primesArray = [primes.topPrime];
  primesArray.reserve(500000);

  ulong primeSumLength(ulong num) {
    ulong sum = 0;
    ulong length;
    size_t i = 0;
    size_t j = 0;

    if (num > primesArray[$-1]) {
      primes
        .tee!(a => primesArray ~= a)
        .find!(a => a > num)
        .front;
    }

    do {
      sum += primesArray[j++];
      length++;

      while (sum > num) {
        sum -= primesArray[i++];
        length--;
      }
    } while (sum != num);

    return length;
  }

  return &primeSumLength;
}
