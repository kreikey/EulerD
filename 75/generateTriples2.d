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
  ulong m1 = 0;
  ulong m2 = 0;
  ulong m3 = 0;
  ulong jkdiff;
  ulong l = 0;
  Tuple!(ulong, ulong, ulong, ulong)[] triangles;
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
      m3 = 1;

      do {
        writeln(a * m3, " ", b * m3, " ", c * m3, " ", l * m3);
        m3++;
      } while (l * m3 <= maxLength);
    }

    if (!resultFound && j % 2 == 1)
      break;
  }
}

/*
auto getPythagoreanTriple(ulong j, ulong k) {
  ulong m1, m2, a, b, c, l;
  ulong jkdiff = j - k;

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
