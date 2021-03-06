#!/usr/bin/env rdmd -I../
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.array;
import std.algorithm;
import std.range;
import std.functional;

void main(string[] args) {
  StopWatch timer;
  int[][] triangle;
  File inFile;
  string fileName = "triangle.txt";
  int sum;
  int[] sums;

  if (args.length > 1) {
    fileName = args[1];
  }

  timer.start();
  inFile = File(fileName);
  triangle = inFile.byLine.map!(line => line.split(" ").map!(numstr => numstr.parse!(int)).array).array();

  sums = getPathSums(triangle);
  sum = sums[0];

  writeln(sum);
  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

int[] getPathSums(int[][] triangle) {
  int[] sums;
  int[] nextSums;

  if (triangle.length == 1)
    return triangle[0];

  sums = getPathSums(triangle[1 .. $]);

  foreach (cell, items; lockstep(triangle[0], sums.slide(2))) {
    nextSums ~= cell + (items[0] > items[1] ? items[0] : items[1]);
  }

  return nextSums;
}
