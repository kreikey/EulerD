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
import kreikey.linkedlist;

void main() {
  StopWatch timer;

  timer.start();
  //writeln(sqrtInt2(8443));

  iota(0uL, uint.max)
    .map!(a => a, a => cast(ulong)(sqrt(real(a))), sqrtInt, sqrtInt2)
    .cache
    .tee!(a => writefln("sqrt(%s): %s, %s, %s", a[0], a[1], a[2], a[3]))
    .until!(a => a[1] != a[2] || a[1] != a[3])(OpenRight.no)
    .each();

  //auto squares = InfiniteIota(1)
    //.map!(a => a^^2)();
  //auto numbers = InfiniteIota(1);
  //auto noSquares = setDifference(numbers, squares);
  //auto DsList = noSquares
    //.until!(a => a > 1000)
    //.map!(a => a, getYMax)
    //.toLinkedList();
  //ulong y = 0;
  //ulong y2 = 0;
  //real intpart;
  //int tooBigCount = 0;

  //do {
    //y++;
    //y2 = y * y;

    //foreach (D; DsList) {
      //if (y2 > D[1]) {
        //DsList.removeCur();
        ////writeln(DsList.length);
        //writefln("%s, %s", D.expand);
        //writeln("too big");
        //tooBigCount++;
      //} else if (modf(sqrt(real(y2 * D[0]) + 1), intpart).feqrel(0.0) > 16) {
        //DsList.removeCur();
        ////writeln(DsList.length);
      //}
    //}
  //} while (!DsList.empty);

  //writefln("too big count: %s", tooBigCount);

  //auto num = noSquares
    //.enumerate
    //.map!(a => a[0], a => a[1], a => diophantineMinX(long(a[1])))
    //.cache
    //.until!(a => a[1] > 1000)
    ////.filter!(a => a[2] == -1)
    //.tee!(a => writefln("i: %s, d: %s, x: %s", a.expand))
    //.count!(a => a[2] == 0)();

  //writeln(num);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}


ulong getYMax(ulong D) {
  return cast(ulong)(sqrt(real(ulong.max - 1)/D));
}

T sqrtInt2(T)(T n)
if (isIntegral!T || is(T == BigInt)) {
  if (n == 0 || n == 1)
    return n;

  T minRoot = cast(T)pow(10, (countDigits(n) - 1) / 2);
  T maxRoot = n / 2;
  T delta = maxRoot - minRoot;
  T halfDelta;
  T candidate;
  T candidateSq;

  do {
    halfDelta = delta / 2 + delta % 2;
    candidate = minRoot + halfDelta;
    candidateSq = candidate ^^ 2;
    if (candidateSq >= n)
      maxRoot = candidate;
    if (candidateSq <= n)
      minRoot = candidate;
    delta = maxRoot - minRoot;
    //writeln("delta: ", delta);
  } while (delta > 1);

  if (candidateSq > n)
    candidate--;

  return candidate;
}

//auto diophantineMinX(ulong d) {
  //real x = 0;
  //ulong y = 0;
  //ulong y2;
  //ulong x2;
  //real intpart;
  //real xfrac;
  //ulong result;

  //do {
    //y++;

    //try {
      //y2 = (checked!Throw(y) * y).get;
      //x2 = (checked!Throw(y2) * d + 1).get;
    //} catch (Exception e) {
      //return 0;
    //}

    //x = sqrt(real(x2));
    //xfrac = modf(x, intpart);
  //} while (xfrac.feqrel(0.0) <= 16);
  
  //result = cast(ulong)x;

  //return result;
//}

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
