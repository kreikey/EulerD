#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import kreikey.intmath;
import kreikey.util;
import kreikey.bigint;

void main() {
  StopWatch timer;

  timer.start();
  auto squares = InfiniteIota(2)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(2);
  auto noSquares = setDifference(numbers, squares);
  //noSquares.take(100).writeln();
  //noSquares.enumerate(1).until!(a => a[1] == 61).each!writeln();
  auto num = noSquares
    .map!(a => diophantineMinX(long(a)))
    .enumerate
    .take(1000)
    .tee!(a => writefln("i: %s x: %s", a[0], a[1]))
    .count!(a => a[1] == -1)();
  writeln(num);
  //auto n = noSquares.take(54).tail(1).front;
  //writeln(n);
  //writeln(diophantineMinX(BigInt(73)));
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto diophantineMinX(long d) {
  long x = 1;
  long y = 1;
  long a = 0;
  long b = 0;
  long diff1 = 0;
  long diff2 = 0;
  long diff3 = 0;
  long diffdiff = 0;
  ulong iterations = 0;
  //writeln("D: -------------------------------------------------------------------------- ", d);
  do {
    a = x^^2;
    b = d*y^^2;
    while (a - b < 1)
      a = (++x) ^^ 2;
    while (a - b > 1)
      b = d * (++y) ^^ 2;
    iterations++;
    if (iterations == 5000000)
      return long(-1);
  } while (a - b != 1);

  return x;
}
