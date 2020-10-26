#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import kreikey.intmath;

void main() {
  ulong totient, totient2;

  for (int n = 1; n <= 10000; n++) {
    assert(getTotient(n) == getTotient2(n));
    totient = getTotient(n);
    totient2 = getTotient2(n);
    writefln("n: %s getTotient: %s getTotient2: %s", n, totient, totient2);
  }
  //getTotient2(1).writeln();
}
