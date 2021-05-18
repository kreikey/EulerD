#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;
import std.traits;
import kreikey.primes;

//bool delegate(int) isPrime;
ReturnType!(isPrimeInit!ulong) isPrime;

static this() {
  isPrime = isPrimeInit!ulong();
}

void main() {
  StopWatch timer;
  timer.start();

  for (ulong n = cast(ulong)(uint.max) * 1000; n > 0; n--) {
    if(isPrime(n)) {
      writeln(n);
      break;
    }
  }

  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
