#!/usr/bin/env rdmd

import std.stdio;
import std.datetime.stopwatch;

void main() {
  StopWatch timer;
  int fibNum;
  int fibA = 0;
  int fibB = 1;
  int fibEvenSum;

  timer.start();
  while (fibNum <= 4000000) {
    if (fibNum % 2 == 0) {
      fibEvenSum += fibNum;
    }
    fibNum = fibB + fibA;
    fibA = fibB;
    fibB = fibNum;
  }
  timer.stop();
  writeln(fibEvenSum);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}
