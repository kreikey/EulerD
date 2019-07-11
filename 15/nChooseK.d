#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;

void main(string[] args) {
  int width = 20, height = 20;
  ulong result;
  StopWatch sw;

  if (args.length > 2) {
    width = args[1].parse!(int);
    height = args[2].parse!(int);
  }

  sw.start();
  result = countLatticePaths(width, height);
  sw.stop();
  writefln("The number of lattice paths in a %sx%s grid from top left to bottom right are:\n%s",
      width, height, result);
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

ulong countLatticePaths(int width, int height) {
  return nChooseK(width + height, width);
}

ulong nChooseK(int n, int k) {
  int numerator, denominator;
  ulong result;

  numerator = n - k + 1;
  denominator = 2;
  result = 1;

  while (numerator <= n && denominator <= n - k) {
    result *= numerator++;

    if (result % denominator == 0)
      result /= denominator++;
  }

  return result;
}
