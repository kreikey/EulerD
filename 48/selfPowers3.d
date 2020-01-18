#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import std.datetime.stopwatch;
import kreikey.bigint;
import kreikey.intmath;
import kreikey.bytemath;

void main() {
  StopWatch timer;
  BigInt sum = 0;
  BigInt temp = 0;
  BigInt product = 1;

  timer.start();
  writeln("Self powers");

  foreach (n; 1u..1001u) {
    if (n % 10 == 0)
      continue;

    temp = n;

    foreach (k; 0..n) {
      product *= temp;

      if (product.length > 10) {
        product.length = 10;
      }
    }

    sum += product;

    if (sum.length > 10)
      sum.length = 10;

    product = 1;
  }

  writefln("The last 10 digits of the sum of self-powers n^n from 1 through 1000 are:\n%s", sum.digitString[$-10..$]);
  //9110846700
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
