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

//alias isTriangularFast = memoize!(isTriangular);
typeof(isTriangularInit()) isTriangular;
alias TriGen = (a, n) => a[n - 1] + n;
//alias Triangulars = typeof(recurrence!(TriGen)(0));
//alias Triangulars = ReturnType!(recurrence!(TriGen, int));

static this() {
  //writeln(typeof(recurrence!((a, n) => a[n-1] + n)(0)).stringof);
  //writeln(Triangulars.stringof);
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
  //auto triangulars = new Triangulars([0]);
  auto temp = recurrence!(TriGen)(0);
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

