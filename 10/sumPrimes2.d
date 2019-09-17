#!/usr/bin/env rdmd -I..
import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import kreikey.primes;

alias partial!(std.algorithm.reduce!((a, b) => a + b), 0) addn;

void main(string[] args) {
  StopWatch timer;
  auto p = new Primes!int(1000);
  int limit = 2_000_000;
  int sum;

  if (args.length > 1)
    limit = args[1].parse!(int);

  timer.start();

  sum = p.until!((a, b) => a >= b)(limit).addn();

  timer.stop();

  writefln("The sum of all primes below %s is %s.", limit, sum);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
