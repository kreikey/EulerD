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
bool delegate(ulong) isTriangular;

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
  auto triangulars = sequence!((s, n) => (n+1)*(n+2)/2)();
  bool[ulong] cache = null;

  bool isTriangular(ulong num) {
    if (num < triangulars.front)
      return num in cache ? true: false;

    while (triangulars.front < num) {
      cache[triangulars.front] = true;
      triangulars.popFront();
    }

    return num == triangulars.front;
  }

  return &isTriangular;
}

