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

  auto numbers = [1, 2, 3, 4, 5, 6, 7].toLinkedList();
  auto numrange = numbers.byItem();
  writeln(numrange);
  numrange.drop(3).removeFront();
  writeln(numrange);
  numrange.popFront();
  numrange.popBack();
  writeln(numrange);
  numbers.printList();
  foreach (n; 0..2)
    numrange.removeFront();
  writeln(numrange);
  numrange.removeBack();
  writeln(numrange);
  numrange.removeBack();
  writeln(numrange);
  numbers.printList();
  numrange = numbers.byItem();
  writeln(numrange);
  numrange.removeFront();
  numrange.removeFront();
  writeln(numrange);
  numbers.printList();
  //auto squares = InfiniteIota(1)
    //.map!(a => a^^2)();
  //auto numbers = InfiniteIota(1);
  //auto noSquares = setDifference(numbers, squares);
  //auto Ds = noSquares.until!(a => a > 1000).toLinkedList.byItem();

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
