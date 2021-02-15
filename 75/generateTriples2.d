#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.math;
import std.typecons;
import std.conv;
import kreikey.intmath;
import kreikey.util;

void main() {
  ulong maxLength = 1500000;
  ulong a = 0;
  ulong b = 0;
  ulong c = 0;
  ulong m = 0;
  ulong l = 0;
  Tuple!(ulong, ulong, ulong, ulong) triangle;
  bool resultFound = true;

  for (ulong j = 2;; j++) {
    resultFound = false;

    foreach (k; j.getCoprimes()) {
      triangle = getPythagoreanTriple(j, k);

      a = triangle[0];
      b = triangle[1];
      c = triangle[2];
      l = triangle[3];

      if (a > b || l > maxLength)
        continue;

      resultFound = true;
      m = 1;

      do {
        writeln(a * m, " ", b * m, " ", c * m, " ", l * m);
        m++;
      } while (l * m <= maxLength);
    }

    if (!resultFound && j % 2 == 1)
      break;
  }
}

/*
auto getPythagoreanTriple(T)(T j, T k) if (isIntegral!T) {
  assert (j > k && k > 0);

  T m1, m2, a, b, c, l;
  T jkdiff = j - k;

  if (jkdiff % 2 == 0) {
    m1 = jkdiff / 2;
    m2 = 1;
    c = (j^^2 + k^^2) / 2;
  } else {
    m1 = jkdiff;
    m2 = 2;
    c = j^^2 + k^^2;
  }

  a = m1*(j+k);
  b = m2*j*k;
  //c = cast(ulong)sqrt(real(a ^^ 2 + b^^2));
  l = a + b + c;

  return tuple(a, b, c, l);
}
*/
