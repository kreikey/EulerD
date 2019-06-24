#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import kreikey.primes;

void main () {
  StopWatch sw;
  auto p = new Primes!long();
  long num = 600851475143;

  sw.start();
  do {
    if (num % p.front == 0) {
      num = num / p.front;
    }
    p.popFront();
  } while (num != p.front);
  sw.stop();

  writeln(num);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
