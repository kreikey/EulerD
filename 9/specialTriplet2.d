#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.math;
import pythagoreanTriplet;
import std.datetime.stopwatch;

void main() {
  ulong b;
  ulong c;
  StopWatch timer;

  // implemented a more efficient, more specialized algorithm here.
  timer.start();
  for (ulong a = 1; a < 500; a++) {
    if (1000 * (500 - a) % (1000 - a) == 0) {
      b = 1000 * (500 - a) / (1000 - a);
      c = 1000 - a - b;
      writefln("%s^2 + %s^2 = %s^2", a, b, c);
      writefln("%s + %s = %s", a*a, b*b, c*c);
      writefln("%s + %s + %s = %s", a, b, c, a + b + c);
      writefln("%s * %s * %s = %s", a, b, c, a * b * c);
      break;
    }
  }
  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
