#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.functional;
import std.conv;
import std.range;
import kreikey.fibonacci;

void main(string[] args) {
  static assert(isInputRange!(Fibonacci));
  static assert(isInfinite!(Fibonacci));
  static assert(isForwardRange!(Fibonacci));

  StopWatch sw;
  auto fib = new Fibonacci();
  ulong limit = 4000000;
  ulong result;

  if (args.length > 1)
    limit = args[1].parse!(ulong);

  sw.start();

  result = fib.until!(a => a >= limit).filter!(a => a % 2 == 0).sum();

  sw.stop();
  writeln("The sum of even fibonacci numbers not greater than ", limit, " is:\n", result);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds.");
}
