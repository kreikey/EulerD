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

  auto squares = InfiniteIota(1)
    .map!(a => a^^2)();
  auto numbers = InfiniteIota(1);
  auto noSquares = setDifference(numbers, squares);
  auto DsList = noSquares.until!(a => a > 1000).toLinkedList();

  ulong x = 1;
  ulong x2;
  enum xmax = cast(ulong)sqrt(real(ulong.max));
  writeln(xmax);
  auto Ds = DsList.byItem();
  real intpart;
  bool didRemove = false;

  do {
    x++;
    x2 = x * x;

    writeln(DsList.byItem.take(10));
    Ds = DsList.byItem();
    //writefln("x: %s", x);

    for (auto DsCopy = Ds; !DsCopy.empty; DsCopy.popFront()) {
      auto D = DsCopy.front;
      //if (DsList.length == 965) {
        //writeln("Still trucking");
      //}
      if ((x2 - 1) % D == 0) {
        //writefln("x^2 - 1 is divisible by %s", D);
        if (modf(sqrt(real(x2 - 1)/D), intpart).feqrel(0.0) > 16) {
          writefln("(%s^2 - 1) / %s is square", x, D);
          writeln(D);
          writeln(Ds.front);
          //printList(DsList);
          writeln(Ds.frontNode);
          writeln(Ds.frontNode.next);
          writeln(Ds.frontNode.prev);
          //printList(DsList);
          writeln(DsList.first.payload);
          Ds.removeFront();
          //didRemove = true;
          //printList(DsList);
          writeln(Ds.front);
          writeln(DsList.length);
        }
      }
      //if (!didRemove)
        //Ds.popFront();
      //didRemove = false;
    }
  } while (x < xmax);

  //writeln(Ds.front);
  //Ds.popFront();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.popFront();
  //writeln(Ds.front);

  //Ds.removeFront();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.removeFront();
  //Ds = DsList.byItem();
  //Ds.popFront();
  //Ds.popFront();
  //Ds.removeFront();
  //DsList.printList();

  //writeln(DsList.byItem());

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
