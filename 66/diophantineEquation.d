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
  writeln(isqrt(99));
  int remainder;
  int root;

  foreach (n; iota(0, 101)) {
    root = isqrt(n, remainder);
    writefln("sqrt(%s) = %s r %s", n, root, remainder);
  }

  //auto squares = InfiniteIota(1)
    //.map!(a => a^^2)();
  //auto numbers = InfiniteIota(1);
  //auto noSquares = setDifference(numbers, squares);
  //auto DsList = noSquares
    //.until!(a => a > 1000)
    //.map!(a => a, getYMax)
    //.toLinkedList();
  //ulong y = 0;
  //real x = 0;
  //ulong y2 = 0;
  //real intpart;
  int bigCount = 0;
  //ulong Dmax = 0;
  //ulong xmax = 0;
  //BigInt x2 = 0;
  //BigInt xBig = 0;

  //do {
    //y++;

    //foreach (D; DsList) {
      //if (y > D[1]) {
        //x2 = BigInt(y) * y * D[0] + 1;
        //xBig = sqrtInt(x2);
        //if (xBig ^^ 2 != x2)
          //continue;
        //if (xBig > xmax) {
          //xmax = cast(ulong)xBig;
          //Dmax = D[0];
        //}
        //DsList.removeCur();
        ////writeln(DsList.length);
        //writefln("D: %s, ymax: %s, big", D.expand);
        //bigCount++;
      //} else {
        //x = sqrt(real(y * y * D[0]) + 1);
        //if (modf(x, intpart).feqrel(0.0) >= 16)
          //continue;
        //if (x > xmax) {
          //xmax = cast(ulong)x;
          //Dmax = D[0];
        //}
        //DsList.removeCur();
        //writefln("D: %s, ymax: %s", D.expand);
        ////writeln(DsList.length);
      //}
    //}
  //} while (!DsList.empty);

  writefln("big count: %s", bigCount);

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
