#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import std.math;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;
import kreikey.bigint;

void main() {
  StopWatch timer;

  timer.start();
  writeln("long.max: ", long.max);
  writeln("long.max digit count: ", countDigits(long.max));
  auto squares = InfiniteIota(2)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(2);
  auto noSquares = setDifference(numbers, squares);
  auto num = noSquares
    .enumerate
    .map!(a => a[0], a => a[1], a => diophantineMinX(long(a[1])))
    .cache
    .until!(a => a[1] > 1000)
    //.filter!(a => a[2] == -1)
    .tee!(a => writefln("i: %s, d: %s, x: %s", a.expand))
    .count!(a => a[2] == -1)();
  writeln(num);
  //writeln(diophantineMinX(61));
  //real rem;
  //int quo;
  //writeln(remquo(5.0, 2.0, quo));
  //writeln(quo);
  /* solution for 109 is:
     25910770249
 */
  //auto x = 25910770249L;
  //auto y2 = (x ^^ 2 - 1) / 109;
  //long y = cast(long)sqrt(real(y2));
  //writefln("%.10f", sqrt(real(y2)));
  //writeln(y);
  //writefln("%s^2 - 109 * %s^2 = %s", x, y, x ^^ 2 - 109 * y ^^ 2);
  ////Finished in 1760281 milliseconds.
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto diophantineMinX(long d) {
  long x = 1;
  real y = 1.5;
  long temp;
  real frac;
  real intpart;

  do {
    x++;
    temp = x * x - 1;

    if (temp % d != 0)
      continue;

    y = sqrt(real(temp)/d);
    frac = modf(y, intpart);
    if (x > 1000000)
      return (-1);
  } while (frac.feqrel(0.0) <= 16);

  return x;
}
