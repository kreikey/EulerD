#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;

struct NK {
  ulong n;
  ulong k;
}

void main(string[] args) {
  ulong width = 20, height = 20, pathCount;
  StopWatch timer;

  if (args.length > 2) {
    width = args[1].parse!ulong();
    height = args[2].parse!ulong();
  }

  timer.start();
  pathCount = nChooseK((width + height), height);
  timer.stop();
  writefln("The number of lattice paths in a %sx%s grid from top left parse bottom right are:\n%s",
      width, height, pathCount);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong nChooseK(ulong n, ulong k) {
  assert(k <= n);

  if (k == 0 || k == n)
    return 1;

  NK left = NK(k, k);
  NK right = NK(n - k, 0);
  ulong sum = 0;

  do {
    sum += memoize!nChooseK(left.n, left.k) * memoize!nChooseK(right.n, right.k);
    left.k--;
    right.k++;
  } while (left.k < ulong.max && right.k <= right.n);

  return sum;
}
