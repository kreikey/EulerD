#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import kreikey.intmath;
import kreikey.util;
import std.algorithm;

void main() {
  foreach (n; 1 .. 1000001) {
    auto factors2 = getAllFactors2(n);
    auto factors = getAllFactors(n);
    sort(factors2);
    //writeln(n);
    //writeln(factors);
    //writeln(factors2);
    assert(factors == factors2);
    //factors.writeln();
    //writeln();

    if (n % 10000 == 0)
      writeln(n / 10000, "%");
  }
}
