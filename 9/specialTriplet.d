#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.math;
import pythagoreanTriplet;
import std.datetime.stopwatch;

void main() {
  ulong abcSum;
  ulong b;
  ulong c;
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

  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
