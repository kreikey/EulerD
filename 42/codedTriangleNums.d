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
  auto temp2 = new typeof(temp);
  *temp2 = temp;
  auto triangulars = refRange(temp2);
  bool[ulong] cache = null;

  bool isTriangular(ulong num) {
    if (triangulars.front <= num)
      triangulars.tee!(a => cache[a] = true)
        .find!(a => a > num)();

    return num in cache ? true : false;
  }

  return &isTriangular;
}

