#!/usr/bin/env rdmd -I.. -i

import std.stdio;
import kreikey.intmath;

void main() {
  foreach (n; 1 .. 1000001) {
    auto factors = getAllFactors2(n);
    //auto factors = getAllFactors(n);
    //factors.writeln();
    //writeln();

    if (n % 10000 == 0)
      writeln(n / 10000, "%");
  }
}
