#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.datetime.stopwatch;
import std.range;
import std.math;
import std.typecons;
import kreikey.intmath;

void main() {
  StopWatch timer;

  timer.start();

  writeln("Ordered fractions");

  //auto fraction = iota(2, 1000001)
    //.filter!(d => d % 7 != 0)
    //.map!(d => cast(int)floor(d * 3. / 7), d => d)
    //.map!(f => double(f[0])/f[1], f => f[0], f => f[1])
    //.fold!max();

  //writefln!"%s/%s = %s"(fraction[1], fraction[2], fraction[0]);

  auto fraction = iota(2, 1000001)
    .filter!(d => d % 7 != 0)
    .map!(d => cast(int)floor(d * 3. / 7), d => d)
    .map!(f => f[0], f => f[1], f => double(f[0])/f[1])
    .fold!((a, b) => a[2] > b[2] ? a : b)();

  writefln!"%s/%s = %s"(fraction.expand);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

