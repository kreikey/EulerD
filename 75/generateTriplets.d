#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.math;

void main() {
  StopWatch timer;
  //int j = 0;
  //int k = 0;
  ulong a = 0;
  ulong b = 0;
  auto someKs = recurrence!((a, n) => (n) % 3 == 0 ? a[n-1] : a[n-1] + 1)(1, 2, 3);
  auto someJs = recurrence!((a, n) => (n-1) % 3 == 0 ? a[n-1] : a[n-1] + 1)(2, 3, 4);
  auto someMs = recurrence!((a, n) => n % 3 == 0 ? 1 : 2)(2, 2, 2);

  foreach (j, k, m; zip(someJs, someKs, someMs).take(1000)) {
    a = j+k;
    b = m*j*k;
    writefln("(%s, %s) a:%s b:%s c:%s", j, k, a, b, sqrt(real(a ^^ 2 + b^^2)));
  }

  // some triplets
  // j: 2 3 4 5 5 6 7 7 8 9 9 10 11 11 12 13 13 14 15 15 16 17 17
  // k: 1 2 3 3 4 5 5 6 7 7 8 9 9 10 11 11 12 13 13 14 15 15 16
  //j-k:1 1 1 2 1 1 2 1 1 2 1 1 2 1  1  2  1  1  2  1  1  2  1
  // m: 2 2 2 1 2 2 1 2 2 1 2 2 1 2  2  1  2  2  1  2  2  1  2

  // recurrence relationship for k:
  // 2 3 3 4 5 5 6 7 7 8 9 9 
  // a[0] + 1, a[1], a[2] + 1, a[3] + 1, a[4], a[5] + 1, a[6] + 1, a[7]
  // (2, 3, 3)
  // h h h


  timer.start();
  timer.stop();

  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}
