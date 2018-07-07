#!/usr/bin/env rdmd -I..

import std.stdio;
import std.range;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.functional;
import kreikey.intmath;
import kreikey.bigint;

alias primeFactorsFast = memoize!primeFactors;

void main(string[] args) {
  StopWatch sw;
  ulong n = 100;

  if (args.length > 1)
    n = args[1].parse!ulong();

  writeln("distinct powers");

  sw.start();

  //iota(2, n + 1)
    //.map!(a => iota(2, n + 1)
        //.map!(b => BigInt(a) ^^ b)
        //.array())
    //.array
    //.multiwayUnion
    //.count
    //.writeln();

    //.map!(b => iota(b).map!(c => primeFactorsFast(a)).array.multiwayMerge.array())

    //.map!(b => iota(b).map!(c => primeFactors(a)).array.multiwayMerge.array())
//iota(b).map!(c => primeFactors(a)).array.multiwayMerge.array())

  //iota(2, n+ 1)
    //.map!(a => iota(2, n+1)
      //.map!(b => iota(b).map!(c => primeFactorsFast(a)).array.multiwayMerge.array())
      //.array())
    //.array
    //.multiwayMerge
    //.uniq
    ////.multiwayUnion
    ////.count
    //.writeln();

  sw.stop();

  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}


