#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.array;
import poker;

void main() {
  StopWatch timer;
  timer.start();

  writeln("Poker Hands");

  auto p1wins = File("p054_poker.txt")
    .byLineCopy
    .map!(a => a.split(' ').map!Card.array())
    .map!(a => Hand(a[0..5]), a => Hand(a[5..$]))
    .count!(a => a[0] > a[1])();

  writefln("Player 1 wins %s hands.", p1wins);
  timer.stop();
  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
