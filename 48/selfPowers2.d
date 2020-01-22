#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.functional;
import std.conv;
import std.array;
import kreikey.bigint;
import kreikey.intmath;
import kreikey.bytemath;

void main() {
  StopWatch timer;
  ubyte[] sum = [0];
  ubyte[] temp;
  ubyte[] product = [1];

  timer.start();
  writeln("Self powers");

  foreach (n; 1..1001) {
    if (n % 10 == 0)
      continue;

    temp = n.rbytes();

    foreach (k; 0..n) {
      product = mul(product, temp);

      if (product.length > 10)
        product.length = 10;
    }

    accumulate(sum, product);

    if (sum.length > 10)
      sum.length = 10;

    product = [1];
  }

  timer.stop();
  writefln("The last 10 digits of the sum of self-powers n^n from 1 through 1000 are:\n%s", sum.rstr());
  //9110846700
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
