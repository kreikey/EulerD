#!/usr/bin/env rdmd -I..
import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import kreikey.primes;

void main(string[] args) {
  StopWatch timer;
  auto p = new Primes!ulong();
  ulong limit = 2_000_000;
  ulong sum;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  timer.start();

  sum = p.until!((a, b) => a >= b)(limit).sum();

  timer.stop();

  writefln("The sum of all primes below %s is %s.", limit, sum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
