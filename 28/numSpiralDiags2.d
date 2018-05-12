#!/usr/bin/env rdmd -I..
import std.stdio;
import std.range;
import std.algorithm;
import std.conv;

void main(string[] args) {
  ulong n = 1001;

  if (args.length > 1)
    n = args[1].to!ulong();

  //diags.take(30).writeln();
  //auto egers = recurrence!((a, n) => a[n-1] + 1)(1);
  //egers.take(100).writeln();
  //auto odds = recurrence!((a, n) => a[n-1] + 2)(1);
  //auto evens = recurrence!((a, n) => a[n-1] + 2)(2);
  //zip(odds, evens).take(100).each(write(e[1]));
  //writeln();
  //auto strides = recurrence!((a, n) => a[n-4] + 2)(1, 2, 2, 2, 2);
  //strides.take(30).writeln();
  //auto spiral = recurrence!((a, n){auto result = a[n-1] + strides.front; strides.popFront; return result;})(1);
  //spiral.take(30).writeln();
  //iota(1, 2).writeln();
  //iota(1, 2)
    //.chain(
    //strides

  recurrence!((a, n) => a[n-4] + 2)(1, 2, 2, 2, 2)
    .cumulativeFold!((a, b) => a + b)(0)
    .take((n - 1) * 2 + 1)
    .sum
    .writeln();
}
