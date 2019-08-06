#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.conv;
import std.array;
import std.range;

void main(string[] args) {
  StopWatch sw;
  int[] digits;
  ulong permCount = 1;
  ulong n;
  ulong sNdx;

  sw.start();
  digits = iota(10).array();
  n = digits.length - 1;

  while (permCount < 1000000) {
    while (n > 0 && digits[n-1] > digits[n]) {
      n--;
    }
    sNdx = n;
    foreach (i, digit; digits[n+1..$]) {
      if (digit < digits[sNdx] && digit > digits[n-1])
        sNdx = i + n + 1;
    }
    swap(digits[sNdx], digits[n-1]);
    sort(digits[n..$]);
    permCount++;
    n = cast(int)digits.length - 1;
  }

  sw.stop();
  writefln("The %sth permutation of digits 0 - 9 is: %s", permCount, digits.map!(a => cast(char)(a + '0'))());
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

