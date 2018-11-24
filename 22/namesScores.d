#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.algorithm;
import std.array;

void main(string args[]) {
  StopWatch sw;
  string filename = "names.txt";
  char[] contents;
  char[][] names;
  int[] values;
  int[] scores;
  ulong total;

  if (args.length > 1) {
    filename = args[1];
  }

  File inFile = File(filename);

  sw.start();

  contents.length = inFile.size;
  inFile.rawRead(contents);

  names = contents.split(",").map!(word => word[1..$-1]).array;
  names.sort;

  values = names.map!(value).array;

  foreach (int i, val; values)
    scores ~= val * (i + 1);

  total = scores.reduce!((a, b) => a + b);

  sw.stop();
  writefln("The total of the scores is: %s", total);
  writefln("finished in %s milliseconds", sw.peek.msecs());
}

int value(ref char[] word) {
  return word.map!(letter => cast(int)(letter - 64)).reduce!((a, b) => a + b);
}
