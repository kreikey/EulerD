#!/usr/bin/env rdmd

import std.stdio;
import std.datetime.stopwatch;

void main() {
  StopWatch sw;
  int fibNum;
  int fibA = 0;
  int fibB = 1;
  int fibEvenSum;

  sw.start();
  while (fibNum <= 4000000) {
    if (fibNum % 2 == 0) {
      fibEvenSum += fibNum;
    }
    fibNum = fibB + fibA;
    fibA = fibB;
    fibB = fibNum;
  }
  sw.stop();
  writeln(fibEvenSum);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}
