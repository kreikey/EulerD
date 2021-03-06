#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.array;
import std.algorithm;

void main(string[] args) {
  StopWatch timer;
  int[][] triangle;
  File inFile;
  string fileName = "triangle.txt";
  int sum;

  if (args.length > 1) {
    fileName = args[1];
  }

  timer.start();
  inFile = File(fileName);
  triangle = inFile.byLine.map!(line => line.split(" ").map!(numstr => numstr.parse!(int)).array()).array();
  sum = biggestPathSum(triangle, 0, 0);
  writeln(sum);
  timer.stop();
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

int biggestPathSum(ref int[][] triangle, int i, int j) {
  int sum, sumA, sumB;

  if (j >= triangle.length) {
    return 0;
  } else {
    if (i >= triangle[j].length)
      return 0;
  }

  sum = triangle[j][i];
  sumA = biggestPathSum(triangle, i, j + 1);
  sumB = biggestPathSum(triangle, i + 1, j + 1);

  sum += sumA > sumB ? sumA : sumB;

  return sum;
}
