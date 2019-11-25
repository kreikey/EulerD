#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.file;
import std.algorithm;
import std.range;
import kreikey.intmath;
import std.functional;
import std.datetime.stopwatch;
import std.typecons;

//alias isTriangularFast = memoize!(isTriangular);
typeof(isTriangularInit()) isTriangular;

static this() {
  isTriangular = isTriangularInit();
}

void main() {
  StopWatch timer;
  string rawData;
  string[] words;

  timer.start();

  //wordsFile = File("p042_words.txt");
  //wordsFile.rawRead(rawData);

  rawData = cast(string)read("p042_words.txt");
  words = rawData.split(',').map!(a => a.strip('"')).array();
  
  //"SKY".map!(a => a - 64).sum.writeln();

  ulong count = words.map!(a => a.map!(a => a - 64).sum())
    .filter!isTriangular
    .tee!(a => write(a, " "))
    .count();
  writeln();

  timer.stop();
  writefln!"There are %s triangular words in the file."(count);
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

auto isTriangularInit() {
  auto temp = recurrence!((a, n) => a[n-1] + n)(0);
  auto triangulars = new typeof(temp)();
  *triangulars = temp;
  bool[ulong] cache = null;

  bool isTriangular(ulong num) {
    if (triangulars.front <= num)
      triangulars.tee!(a => cache[a] = true)
        .find!(a => a > num)();

    return num in cache ? true: false;
  }

  return &isTriangular;
}

