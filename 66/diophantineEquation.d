#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.experimental.checkedint;
import std.math;
import std.traits;
import std.typecons;
import kreikey.intmath;
import kreikey.digits;
import kreikey.util;
import kreikey.bigint;
import kreikey.linkedlist;
import kreikey.primes;

/*
   x^2 - Dy^2 = 1
   x^2 = 1 + Dy^2
   x = sqrt(1 + Dy^2)
   x^2-1 = Dy^2
   sqrt(x^2-1) = sqrt(D)y
   sqrt(x^2-1)/sqrt(D) = y
*/

void main() {
  StopWatch timer;

  timer.start();

  auto squares = InfiniteIota(1)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(1);
  auto noSquares = setDifference(numbers, squares);
  ulong Dmax = 0;
  ulong xmax = 0;
  //auto DsList = noSquares
    //.until!(a => a > 1000)
    //.map!(a => a, getYMax, getRoot, D => BigInt(D))
    //.toLinkedList();
  //ulong y = 0;
  //BigInt yBig = y;
  //ulong x = 0;
  //ulong y2 = 0;
  //real intpart;
  //int bigCount = 0;
  //ulong xint = 0;
  //BigInt x2 = 0;
  //BigInt xBig = 0;
  //BigInt remainder;
  //int line = 1;
  //bool hitBigInt = false;

  //do {
    //y++;
    //yBig++;

    //foreach (D; DsList) {
      //if (y > D[1]) {
        //if (!hitBigInt) {
          //writefln("BigInt mode");
          //hitBigInt = true;
        //}
        //x2 = D[3] * (yBig ^^ 2) + 1;
        //xBig = isqrt(x2, remainder);

        //if (remainder != 0)
          //continue;

        //if (xBig > xmax) {
          //xmax = cast(ulong)xBig;
          //Dmax = D[0];
        //}

        //DsList.removeCur();
        //writefln("line: %s %s^2 - %s*%s^2 = 1, big", line, xBig, D[0], y);
        //line++;
        //bigCount++;
      //} else {
        //x = cast(ulong)ceil(D[2] * y);

        //if (x * x - y * y * D[0] != 1)
          //continue;

        //if (x > xmax) {
          //xmax = x;
          //Dmax = D[0];
        //}

        //DsList.removeCur();
        //writefln("line: %s %s^2 - %s*%s^2 = 1", line, x, D[0], y);
        //line++;
      //}
    //}
  //} while (!DsList.empty);
  //writefln("big count: %s", bigCount);

  Tuple!(ulong, ulong) xy;
  ulong x, y;

  foreach (d; noSquares.until!(a => a > 1000)) {
    xy = diophantineMinX(d);
    x = xy[0];
    y = xy[1];
    writefln("%s^2 - %s*%s^2 = 1", x, d, y);
  }
  //writeln(diophantineMinX(61));

  writefln("D with biggest min x: %s, biggest min x: %s", Dmax, xmax);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

ulong getXMax() {
  return cast(ulong)sqrt(real(ulong.max));
}

ulong getYMax(ulong D) {
  return cast(ulong)(sqrt(real(ulong.max - 1)/D));
}

real getRoot(ulong n) {
  return sqrt(real(n));
}

auto diophantineMinX(ulong d) {
  ulong x = 0;
  ulong y = 0;
  //ulong y2;
  ulong x2;
  real intpart;
  //real xfrac;
  //ulong result;
  //ulong ymax = getYMax(d);
  ulong xmax = getXMax();
  ulong right;
  //BigInt xBig;
  //BigInt yBig;
  //BigInt x2Big;
  //BigInt y2Big;
  //BigInt remainder;
  //BigInt rightBig;
  //bool changeToBig = true;
  ulong xIncrement = d < 5 ? 1 : primeFactors(d).back;
  ulong xBase = d < 5 ? 2 : xIncrement;
  real rootD = getRoot(d);
  bool matchFound = false;
  //int offset = 
  real yEst1;
  real yEst2;
  real xEst;
  real xReal;

  writefln("xbase: %s, xincrement: %s", xBase, xIncrement);

  do {
    //writefln("xBase: %s", xBase);
    //writefln("x: %s y: %s", x, y);
    yEst1 = real(xBase) / rootD;
    y = cast(ulong)round(yEst1);
    xEst = real(y) * rootD;
    x = cast(ulong)round(xEst);
    yEst2 = real(x) / rootD;
    //writefln("x: %s y: %s", x, y);

    if (x < xmax) {
      if (yEst2 < y) {
        xBase += xIncrement;
        //writeln("x/sqrt(D) < y, which means x^2-Dy^2 < 0. Skipping.");
        continue;
      }
      //x2 = x ^^ 2;
      right = d * y ^^ 2 + 1;
      xReal = sqrt(real(right));
      matchFound = modf(xReal, intpart).feqrel(0.0) > 16;
      //writefln("x^2: %s right: %s", x2, right);
      //matchFound = x2 == right;
    } else {
      //if (changeToBig == true) {
        //writeln("Changing to BigInt");
        //xBig = x;
        //x2Big = xBig ^^ 2;
        //yBig = y;
      //}
      //++yBig;
      //rightBig = yBig ^^ 2 * d + 1;
      //while (x2Big < rightBig) {
        //++xBig;
        //x2Big = xBig ^^ 2;
      //}
      //writefln("%s^2*%s+1 = %s; %s^2 = %s", yBig, d, rightBig, xBig, x2Big);
      //if (rightBig < x2Big) {
        //yBig = isqrt((x2Big - 1)/d);
        //writefln("new y: %s", yBig);
      //}
      //changeToBig = false;
      //yEst1 = real(xBase) / rootD;
      //y = cast(ulong)round(yEst1);
      //xEst = real(xBase) * rootD;
      //x = cast(ulong)round(xEst);
      //yEst2 = real(x) / rootD;
      //if (x % 100000 == 0)
        //writefln("big x: %s big y: %s", x, y);
      //matchFound = BigInt(x)^^2 - BigInt(d) * BigInt(y) ^^ 2 == 1;
      x = 0;
      y = 0;
      matchFound = true;
    }
    xBase += xIncrement;
  } while (!matchFound);
  
  //x = y <= ymax ? x : cast(ulong)xBig;
  //y = y <= ymax ? y : cast(ulong)yBig; 

  return tuple(x, y);
}
