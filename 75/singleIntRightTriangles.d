#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.traits;
import std.typecons;
import std.math;
import std.conv;
import kreikey.intmath;
import kreikey.util;

void main() {
  int maxLength = 1500000;
  int a = 1;
  int b = 0;
  ulong count = 0;
  long sum = 0;
  long p = 0;
  long[] perimeters = [];

  auto squares = iota(0L, maxLength / 2)
    .map!(a => a^^2)
    .array();

  for (int c = 3; c < squares.length; c++) {
    b = c - 1;
    a = 1;
    while (a <= b) {
      sum = squares[a] + squares[b];
      if (sum == squares[c]) {
        //writefln("%s^2 + %s^2 = %s^2 p = %s", a, b, c, p);
        writeln(a, " ", b, " ", c, " ", a + b + c);
        a++;
        b--;
      } else if (sum < squares[c]) {
        a++;
        if (a + b + c > maxLength)
          b--;
      } else if (sum > squares[c]) {
        b--;
      }
    }
  }
}

auto getMultiTriplets(T)(T topPerimeter) if (isIntegral!T) {
  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[Tuple!(T, T)] cache;
  //Tuple!(T, T, T)[] result;
  real cmin = topPerimeter / pdiv;
  real bmax = real(topPerimeter) / 2;
  real amax = (topPerimeter - cmin) / 2;
  T[][] aa2;
  T[][] bb2;
  T[][] abc2;

  for (T a = 2; a <= amax; a++) {
    aa2 ~= [a, a^^2];
  }

  for (T b = 3; b <= bmax; b++) {
    bb2 ~= [b, b^^2];
  }

  //foreach (a; aa2) {
    //foreach (b; bb2) {
      //abc2 ~= [a[0], b[0], a[1] + b[1]];
    //}
  //}

  //writeln(abc2.length);
  writeln(aa2.length);
  writeln(bb2.length);

  auto c = sqrt(amax ^^2 + bmax ^^2);
  auto result = c + bmax + amax;
  return result;
}

bool getTriplet(T)(T p, T c, out T b, out T a) if (isIntegral!T) {
  for (b = ceil(real(p - c) / 2).to!T(); b < c; b++) {
    a = p - c - b;
    if (a ^^ 2 + b ^^ 2 == c ^^ 2)
      return true;
  }

  return false;
}

int countTriplets(T)(T perimeter) if (isIntegral!T) {
  assert (perimeter > 0);

  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[] triplets = [];
  T c = ceil(perimeter / pdiv).to!T();
  T b = ceil(real(perimeter - c) / 2).to!T();
  T a = perimeter - c - b;
  T csq = c ^^ 2;
  T absq = a ^^ 2 + b ^^ 2;
  int count = 0;

  do {
    if (absq == csq) {
      count++;
    } else if (absq > csq) {
      c++;
      //a--;
      csq = c ^^ 2;
    }
    b++;
    a--;
    absq = a ^^ 2 + b ^^ 2;
  } while (a > 0);

  return count;
}

auto getMultiTriplets2(T)(T topPerimeter) if (isIntegral!T) {
  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[] result;

  return result;
}

auto getTriplets(T)(T perimeter) if (isIntegral!T) {
  assert (perimeter > 0);

  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[] triplets = [];
  T c = ceil(perimeter / pdiv).to!T();
  T b = ceil(real(perimeter - c) / 2).to!T();
  T a = perimeter - c - b;
  T csq = c ^^ 2;
  T absq = a ^^ 2 + b ^^ 2;

  do {
    if (absq == csq) {
      triplets ~= tuple(a, b, c);
    } else if (absq > csq) {
      c++;
      //a--;
      csq = c ^^ 2;
    }
    b++;
    a--;
    absq = a ^^ 2 + b ^^ 2;
  } while (a > 0);

  return triplets;
}
