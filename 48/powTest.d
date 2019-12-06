#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.range;
import kreikey.bigint;

void main() {
  BigInt res = 0;
  byte[] zeros = repeat!byte(0, 10).array();
  //auto someBytes = iota!ubyte(0, 10).array();
  //writeln(zeros);
  //writeln(someBytes);
  int trZeCount = 0;

  foreach (n; 1..1001) {
    res = BigInt(n)^^n;
    if (res.digitString.length > 9) {
      if (res.digitBytes[$-1] == 0) {
        writeln(n);
        //writeln(res);
        trZeCount++;
      }
    }
      
    //writefln("trailing zeros on self power of %s", n);
  }
  writeln(trZeCount);
}
