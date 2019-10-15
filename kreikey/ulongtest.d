#!/usr/bin/env rdmd -i -I..

import std.stdio;
import kreikey.bigint;

void main() {
  ulong result;
  long source;
  ulong temp;

  source = -15318;
  result = source;

  writefln("source: %s\tresult: %s", source, result);

  temp = 2^^31;
  writefln("temp: %s\tulong.max: %s", temp, ulong.max);
  
  byte littleSource;
  ubyte littleResult;
  ubyte addend;

  littleSource = -45;
  littleResult = littleSource;
  addend = ubyte.max;

  writefln("littleSource: %s\tlittleResult: %s", littleSource, littleResult);
  writefln("%s\t%s\t%s", littleSource, addend, littleSource + addend + 1);

  BigInt bigSource = -45;
  ulong bigResult = cast(ulong)bigSource;

  writefln("bigSource: %s\tcast(ulong)bigSource:%s\t", bigSource, bigResult);

  bigSource = source;
  bigResult = cast(ulong)bigSource;

  writefln("bigSource: %s\tcast(ulong)bigSource:%s\t", bigSource, bigResult);

  long signedResult = cast(long)bigSource;

  writefln("bigSource: %s\tcast(long)bigSource:%s\t", bigSource, signedResult);
}
