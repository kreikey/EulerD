#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;

void main(string[] args) {
  int[] digits;
  char[] result;
  int temp, carryVal, n, sum, pow = 1000;

  if (args.length > 1) {
    pow = args[1].to!int;
  }
  StopWatch sw;


  sw.start();
  digits ~= 1;

  foreach (i; 0 .. pow) {
    foreach (ref digit; digits) {
      temp = digit * 2 + carryVal;

      if (temp > 9) {
        digit = temp % 10;
        carryVal = temp / 10;
      } else {
        digit = temp;
        carryVal = 0;
      }
    }
    if (carryVal) {
      digits ~= carryVal;
      carryVal = 0;
    }

    n = i + 1;
  }

  result = digits.map!(num => cast(char)(num + '0')).array.reverse;
  sum = digits.reduce!((a, b) => a + b);

  sw.stop();
  writefln("2^%s = %s", n, result);
  writefln("the sum of the digits is %s", sum);
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}
