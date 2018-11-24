#!/usr/bin/env rdmd -I..
import std.stdio;
import std.conv;
import std.datetime;
import kreikey.primes;

void main(string args[]) {
  ulong belowNum = 2_000_000;
  ulong sum = 0;
  Primes p = new Primes(1000);

  if (args.length > 1)
    belowNum = args[1].parse!(long);

  StopWatch sw;
  sw.start();
  do {
    sum += p.front;
    p.popFront();
  } while (p.front < belowNum);
  sw.stop();
  writefln("got sum of %s from primes below %s in %s milliseconds", sum, belowNum, sw.peek().msecs());
}
