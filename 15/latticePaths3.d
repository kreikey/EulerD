#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.string;

void main(string[] args) {
  int width = 20, height = 20;
  ulong result;
  StopWatch timer;

  if (args.length > 2) {
    width = args[1].parse!int();
    height = args[2].parse!int();
  }

  timer.start();
  result = countLatticePaths(width, height);
  timer.stop();
  writefln("The number of lattice paths in a %sx%s grid from top left to bottom right are:\n%s",
      width, height, result);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong countLatticePaths(int width, int height) {
  return nChooseK(width + height, height);
}

ulong nChooseK(int n, int k) {
  ulong numerator;
  ulong result;
  ulong lastRes;
  ulong leftDenom;
  ulong rightDenom;

  leftDenom = 2;
  rightDenom = 2;
  result = 1;

  for (numerator = 2; numerator <= n; numerator++) {
    //writefln("%s %s %s %s", numerator, leftDenom, rightDenom, result);
    lastRes = result;
    result *= numerator;
    if (result < lastRes) {
      throw new Exception(format("result: %s < lastRes: %s", result, lastRes));
    }

    if (leftDenom <= k && result % leftDenom == 0) {
      result /= leftDenom++;
    } if (rightDenom <= n - k && result % rightDenom == 0) {
      result /= rightDenom++;
    }
  }

  if (leftDenom != k + 1 || rightDenom != n - k + 1)
    throw new Exception("couldn't divide by k! or (n - k)!");

  return result;
}
