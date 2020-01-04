#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;

void main(string[] args) {
  ulong a;
  ulong b;
  ulong c;
  ulong p = 1000;
  ulong divisor;
  ulong dividend;
  bool tripletFound = false;

  if (args.length > 1) {
    p = parse!ulong(args[1]);
  }

  StopWatch timer;

  timer.start();
  writeln("special pythagorean triplet");

  if (p % 2 != 0) {
    writeln("The perimeter must be even!");
    return;
  }

  for (a = 1; a < p/2; a++) {
    divisor = p * (p / 2 - a);
    dividend = (p - a);
    if (divisor % dividend == 0) {
      b = divisor / dividend;
      c = p - a - b;
      tripletFound = true;
      break;
    }
  }

  if (tripletFound) {
    writefln("%s^2 + %s^2 = %s^2", a, b, c);
    writefln("%s * %s * %s = %s", a, b, c, a * b * c);
  } else {
    writeln("no pythagorean triplet found");
  }

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
