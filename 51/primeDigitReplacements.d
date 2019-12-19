#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import kreikey.primes;
import kreikey.intmath;
import kreikey.combinatorics;
import std.array;

alias permutations = kreikey.combinatorics.permutations;
alias nextPermutation = kreikey.combinatorics.nextPermutation;

void main() {
  StopWatch timer;
  auto primes = new Primes!ulong();

  timer.start();
  auto numGroups = primes
    .map!toDigits
    .find!(a => a.length == 2)
    .until!(a => a.length == 4)
    .chunkBy!((a, b) => a.length == b.length)
    .map!(a => a.array())
    .array();
  //writeln(typeof(numGroups).stringof);
  //writeln(numGroups);
  //writeln(numGroups[0]);
  auto r = replacements(numGroups[$-1]);
  //writeln(typeof(r).stringof);
  //r.group
    //.array
    //.map!(a => a[1], a => a[0])
    //.fold!max
    //.writeln();
  r.each!()();
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

uint[][] replacements(uint[][] source) {
  size_t n = source[0].length;
  uint[] masks = new uint[n];
  masks[] = 0;
  //writeln(masks);
  uint[][] result;
  uint[] row;
  
  masks[0] = 10;
  writeln(masks);
  nextPermutation(masks).writeln();
  writeln(masks);
  nextPermutation(masks).writeln();
  writeln(masks);
  nextPermutation(masks).writeln();
  writeln(masks);
  //foreach (k; iota(1, n)) {
    ////writeln("k: ", k);
    //masks[0..k] = 10;
    ////masks.reverse();
    //do {
      //foreach (e; source) {
        ////writeln(masks);
        //row = e.dup;
        //applyMask(row, masks);
        //result ~= row;
      //}
    //} while (masks.nextPermutation());
    //masks[] = 0;
  //}

  //writeln(source);
  //writeln(result);
  return result;
}

void applyMask(ref uint[] digits, uint[] mask) {
  foreach (ref d, m; lockstep(digits, mask)) {
    if (m == 10)
      d = m;
  }
}
