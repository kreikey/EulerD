#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.concurrency;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.bigint;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Convergents of e");
  alias Eterms = Generator!int;
  auto convergents = ContinuedFraction!(Eterms, BigInt)(new Eterms(&contFracE));
  auto digSum = convergents[99][0]
    .digitBytes
    .sum();

  writeln("The sum of the digits of the numerator of the 100th convergent of the continued fraction of e is:");
  writeln(digSum);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

void contFracE() {
  int k = 2;
  yield(2);
  yield(1);
  yield(2);

  for (int n = 1;; n++) {
    if (n == 3) {
      yield(2 * k);
      k++;
      n = 0;
    } else {
      yield(1);
    }
  }
}
