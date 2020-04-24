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

enum AddSub {Add, Sub}

void main() {
  StopWatch timer;

  timer.start();

  auto squares = InfiniteIota(1)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(1);
  auto noSquares = setDifference(numbers, squares);
  auto operations = only(0, 1, 1, 1).cycle.map!(a => cast(AddSub)a);
  auto DsList = noSquares
    .zip(operations)
    .until!(a => a[0] > 1000)
    .map!(a => a[0], a => getYMax(a[0]), a => a[1])
    .toLinkedList();

  DsList.each!(a => writefln("%s, %s, %s", a.expand))();

  //writefln("D with biggest min x: %s, biggest min x: %s", Dmax, xmax);

  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}


ulong getYMax(ulong D) {
  return cast(ulong)(sqrt(real(ulong.max - 1)/D));
}

auto diophantineMinX(ulong d, AddSub operation) {
  ulong y = 0;
  BigInt xBig;
  BigInt yBig;
  real intpart;
  real xfrac;
  ulong result;
  ulong right;
  BigInt xBig;
  BigInt yBig;
  BigInt x2Big;
  BigInt y2Big;
  BigInt remainder;
  BigInt rightBig;
  bool changeToBig = true;
  ulong xDelta = d.distinctPrimeFactors.fold!((a, b) => a * b)();
  ulong x = xDelta + (operation == AddSub.Add) ? 1 : -1;
  ulong xmax = cast(ulong)sqrt(real(ulong.max));
  ulong ymax = getYMax(d);

  do {
    if (x < xmax) {
      right = y * y * d + 1;
      while (x2 < right) {
        x++;
        x2 = x * x;
      }
    } else {
      if (changeToBig == true) {
        writeln("Changing to BigInt");
      }
      xBig = 0;
      yBig = 0;
      changeToBig = false;
    }
    x += xDelta;
  } while (y <= ymax ? (x2 != right) : (x2Big != rightBig));
  
  x = y <= ymax ? x : cast(ulong)xBig;
  y = y <= ymax ? y : cast(ulong)yBig; 

  return tuple(x, y);
}
