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

void main() {
  StopWatch timer;

  timer.start();

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
  //int bigCount = 0;
  //ulong Dmax = 0;
  //ulong xmax = 0;
  //ulong xint = 0;
  //BigInt x2 = 0;
  //BigInt xBig = 0;
  //BigInt remainder;
  //ulong yprev;
  //ulong ydiff;

  //do {
    //y++;

    //foreach (D; DsList) {
      //if (y > D[1]) {
        //x2 = BigInt(D[0]) * y * y *  + 1;
        //xBig = isqrt(x2, remainder);

        //if (remainder != 0)
          //continue;

        //ydiff = y - yprev;
        //yprev = y;

        //if (xBig > xmax) {
          //xmax = cast(ulong)xBig;
          //Dmax = D[0];
        //}

        //DsList.removeCur();
        //writefln("%s^2 - %s*%s^2 = 1\tydiff: %s, big", xBig, D[0], y, ydiff);
        //bigCount++;
      //} else {
        //x = sqrt(real(D[0] * y * y) + 1);

        //if (modf(x, intpart).feqrel(0.0) < 16)
          //continue;

        //ydiff = y - yprev;
        //yprev = y;

        //xint = cast(ulong)intpart;

        //if (xint > xmax) {
          //xmax = xint;
          //Dmax = D[0];
        //}

        //DsList.removeCur();
        //writefln("%s^2 - %s*%s^2 = 1\tydiff: %s", xint, D[0], y, ydiff);
      //}
    //}
  //} while (!DsList.empty);

  //writefln("big count: %s", bigCount);
  //writefln("D with biggest min x: %s, biggest min x: %s", Dmax, xmax);

  auto primes = new Primes!ulong();
  auto parr = primes.until!(a => a >= 1001).array();
  auto result = tuple(0uL, 0uL);
  //writeln(parr);

  //foreach (p; parr) {
    //result = diophantineMinX(p);
    //writefln("D: %s\tx: %s\ty: %s", p, result.expand);
  //}

  //writeln(diophantineMinX(parr[$-1]));
  //writeln(diophantineMinX(997));
  //writeln(parr[$-2]);
  //writeln(diophantineMinX(parr[$-2]));
  writeln(diophantineMinX(109));

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}


ulong getYMax(ulong D) {
  return cast(ulong)(sqrt(real(ulong.max - 1)/D));
}

auto diophantineMinX(ulong d) {
  ulong x = 0;
  ulong y = 0;
  ulong y2;
  ulong x2;
  real intpart;
  real xfrac;
  ulong result;
  ulong ymax = getYMax(d);
  ulong right;
  BigInt xBig;
  BigInt yBig;
  BigInt x2Big;
  BigInt y2Big;
  BigInt remainder;
  BigInt rightBig;
  bool changeToBig = true;

  writeln(ymax);
  do {
    if (y < ymax) {
      y++;
      right = y * y * d + 1;
      while (x2 < right) {
        x++;
        x2 = x * x;
      }
    } else {
      if (changeToBig == true) {
        writeln("Changing to BigInt");
        xBig = x;
        x2Big = xBig ^^ 2;
        yBig = y;
      }
      ++yBig;
      rightBig = yBig ^^ 2 * d + 1;
      while (x2Big < rightBig) {
        ++xBig;
        x2Big = xBig ^^ 2;
      }
      writefln("%s^2*%s+1 = %s; %s^2 = %s", yBig, d, rightBig, xBig, x2Big);
      if (rightBig < x2Big) {
        yBig = isqrt((x2Big - 1)/d);
        writefln("new y: %s", yBig);
      }
      changeToBig = false;
    }

  } while (y <= ymax ? (x2 != right) : (x2Big != rightBig));
  
  x = y <= ymax ? x : cast(ulong)xBig;
  y = y <= ymax ? y : cast(ulong)yBig; 

  return tuple(x, y);
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
