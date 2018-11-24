#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;

void main(string args[]) {
  StopWatch sw;
  char[] digits;
  ulong permCount = 1;
  int n;
  int sNdx;

  sw.start();
  digits = "0123456789".dup;
  n = cast(int)digits.length - 1;

  while (permCount < 1000000) {
    while (n > 0 && digits[n-1] > digits[n]) {
      n--;
    }
    sNdx = n;
    foreach (int i, digit; digits[n+1..$]) {
      if (digit < digits[sNdx] && digit > digits[n-1])
        sNdx = i + n + 1;
    }
    swap(digits[sNdx], digits[n-1]);
    digits[n..$].sort;
    permCount++;
    n = cast(int)digits.length - 1;
  }

  sw.stop();
  writefln("The %sth permutation of digits 0 - 9 is: %s", permCount, digits);
  writefln("finished in %s milliseconds", sw.peek.msecs());
}

void swap(ref char a, ref char b) {
  char temp;

  temp = a;
  a = b;
  b = temp;
}
