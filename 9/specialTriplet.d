#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.math;
import pythagoreanTriplet;
import std.datetime.stopwatch;

void main() {
  int abcSum;
  int b;
  int c;
  StopWatch timer;

  PythagoreanTriplet pyTrip = new PythagoreanTriplet(1000);
  timer.start();
  while (pyTrip.getA() + pyTrip.getB() + pyTrip.getC() != 1000 && !pyTrip.isFinished()) {
    pyTrip.nextTriplet();
  }
  if (!pyTrip.isFinished()) {
    writefln("%s^2 + %s^2 = %s^2", pyTrip.getA(), pyTrip.getB(), pyTrip.getC());
    writefln("%s + %s = %s", pyTrip.getASquared(), pyTrip.getBSquared(), pyTrip.getCSquared());
    writefln("%s + %s + %s = %s", pyTrip.getA(), pyTrip.getB(), pyTrip.getC(), (pyTrip.getA() + pyTrip.getB() + pyTrip.getC()));
    writefln("%s * %s * %s = %s", pyTrip.getA(), pyTrip.getB(), pyTrip.getC(), (pyTrip.getA() * pyTrip.getB() * pyTrip.getC()));
  }
  timer.stop();


  // implemented a more efficient, more specialized algorithm here.
/*  timer.start();
  for (int a = 1; a < 500; a++) {
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
  timer.stop();*/
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
