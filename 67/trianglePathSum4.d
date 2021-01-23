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

  sum = getPathSums(triangle, 0);

  writeln(sum);
  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

int getPathSums(int[][] triangle, ulong topIndex) {
  if (triangle.length == 0)
    return 0;

  int topNum = triangle[0][topIndex];
  int left = memoize!getPathSums(triangle[1 .. $], topIndex);
  int right = memoize!getPathSums(triangle[1 .. $], topIndex + 1);

  return topNum + (left > right ? left : right);
}
