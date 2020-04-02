#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import std.math;
import std.traits;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;
import kreikey.bigint;

//ReturnType!isSquareInit isSquare;

//static this() {
  //isSquare = isSquareInit();
//}

void main() {
  StopWatch timer;

  timer.start();
  //writeln("long.max: ", long.max);
  //writeln("long.max digit count: ", countDigits(long.max));
  //writeln("ulong.max: ", ulong.max);
  //writeln("ulong.max digit count: ", countDigits(ulong.max));

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
    .count!(a => a[2] == 0)();

  writeln(num);

  //squares.take(100).each!writeln();
  //writeln(isSquare(BigInt(64)));
  //writeln(isSquare(BigInt(81)));
  //writeln(isSquare(BigInt(31)));
  //writeln(isSquare(BigInt(32)));
  //writeln(isSquare(BigInt(36)));
  /*
  solution for 61 is:
    x = 1766319049
    y = 226153980
  solution for 109 is:
    x = 25910770249
    y = 258528444
  other solution for 109 is:
    x = 3539489033
    y = 2387410668
  */
  ulong d;
  ulong y;
  ulong x;

  //d = 109;
  //y = 2387410668;
  //x = cast(ulong)real(y * y * d + 1).sqrt();
  ////writefln("%s^2 - %s * %s^2 = %s", x, d, y, checked!Throw(x ^^ 2 - d * y ^^ 2).get);
  //writefln("%s^2 - %s * %s^2 = %s", x, d, y, BigInt(x) ^^ 2 - BigInt(d) * BigInt(y) ^^ 2);
  //auto y2 = (checked!Throw(y) * y).get;
  //writeln(y2);
  //auto dy2 = (checked!Throw(d) * y2).get;
  //writeln(dy2);
  //writeln(x);
  //auto x2 = (checked!Throw(x) * x).get;
  //writeln(x2);
  //auto by2 = BigInt(y) * BigInt(y);
  //writeln("big: ", by2);
  //auto bdy2 = BigInt(d) * by2;
  //writeln("big: ", bdy2);
  //auto bx2 = BigInt(x) * BigInt(x);
  //writeln("big: ", bx2);

  //d = 109;
  //x = 25910770249;
  //y = cast(ulong)real((x * x - 1)/d).sqrt();
  ////writefln("%s^2 - %s * %s^2 = %s", x, d, y, checked!Throw(x ^^ 2 - d * y ^^ 2).get);
  //writefln("%s^2 - %s * %s^2 = %s", x, d, y, BigInt(x) ^^ 2 - BigInt(d) * BigInt(y) ^^ 2);

  //d = 61;
  //x = 1766319049;
  //y = cast(ulong)real((x * x - 1)/d).sqrt();
  ////writefln("%s^2 - %s * %s^2 = %s", x, d, y, checked!Throw(x ^^ 2 - d * y ^^ 2).get);
  //writefln("%s^2 - %s * %s^2 = %s", x, d, y, BigInt(x) ^^ 2 - BigInt(d) * BigInt(y) ^^ 2);

  //writefln("%s^2 - %s * %s^2 = %s", x, d, y, x ^^ 2 - d * y ^^ 2);

  /*
  x: 3.53949e+09, y: 2387410668, xfrac: 0
  3539489033
  */

  writeln(diophantineMinX(61));
  ////Finished in 1760281 milliseconds.
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto diophantineMinX(ulong d) {
  real x = 0;
  ulong y = 0;
  ulong y2;
  ulong x2;
  real intpart;
  real xfrac;
  ulong result;

  do {
    y++;

    try {
      y2 = (checked!Throw(y) * y).get;
      x2 = (checked!Throw(y2) * d + 1).get;
    } catch (Exception e) {
      return 0;
    }

    x = sqrt(real(x2));
    xfrac = modf(x, intpart);
  } while (xfrac.feqrel(0.0) <= 16);
  
  result = cast(ulong)x;

  return result;
}

// xfrac.feqrel(0.0) <= 16
// x * x != x2
// writefln("x: %s, y: %s, xfrac: %s", result, y, xfrac);

//bool isSquare(ulong num) {
  //auto factors = num.primeFactors();
  //auto factorGroups = factors.group();
  //return factorGroups.all!(a => a[1] % 2 == 0);
//}

//auto isSquareInit() {
  //bool[BigInt] squaresCache;
  //auto squares = InfiniteIota(2uL).map!(a => BigInt(a)^^2);
  //bool isSquare(BigInt num) {
    //refRange(&squares)
      //.until!((a, b) => a > b)(num)
      //.each!(a => squaresCache[a] = true)();
    //return num in squaresCache ? true : false;
  //}
  //return &isSquare;
//}
