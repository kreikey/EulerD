#!/usr/bin/env rdmd -I..
import std.stdio;
import std.conv;
import std.datetime.stopwatch;
import kreikey.primes;

void main(string[] args) {
  int belowNum = 2_000_000;
  int sum = 0;
  auto p = new Primes!int(1000);

  if (args.length > 1)
    belowNum = args[1].parse!(int);

  StopWatch timer;
  timer.start();
  do {
    sum += p.front;
    p.popFront();
  } while (p.front < belowNum);
  timer.stop();
  writefln("got sum of %s from primes below %s in %s milliseconds", sum, belowNum, timer.peek().total!"msecs"());
}
