#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import kreikey.primes;

void main () {
  StopWatch timer;
  auto p = new Primes!long();
  long num = 600851475143;

  timer.start();
  do {
    if (num % p.front == 0) {
      num = num / p.front;
    }
    p.popFront();
  } while (num != p.front);
  timer.stop();

  writeln(num);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
