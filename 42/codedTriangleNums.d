#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.file;
import std.algorithm;
import std.range;
import kreikey.intmath;
import std.functional;
import std.datetime.stopwatch;
import std.typecons;
import std.traits;
import std.utf;

typeof(isTriangularInit()) isTriangular;

static this() {
  isTriangular = isTriangularInit();
}

void main() {
  StopWatch timer;

  timer.start();
  writeln("Coded triangle numbers");

  auto count = readText("p042_words.txt")
    .split(',')
    .map!(a => a.strip('"'))
    .array
    .map!(a => a.map!(a => a - 64).sum())
    .filter!isTriangular
    .tee!(a => write(a, " "))
    .count();

  writeln();
  timer.stop();

  writefln!"There are %s triangular words in the file."(count);
  writefln!"Finished in %s milliseconds."(timer.peek.total!"msecs"());
}

auto isTriangularInit() {
  auto temp = recurrence!((a, n) => a[n - 1] + n)(0);
  bool[ulong] cache = null;

  bool isTriangular(ulong num) {
    auto triangulars = refRange(&temp);
    if (triangulars.front <= num)
      triangulars.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  }

  return &isTriangular;
}

