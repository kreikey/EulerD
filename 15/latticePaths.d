#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;

void main(string[] args) {
  int width = 20, height = 20;
  ulong pathCount;

  StopWatch timer;

  if (args.length > 2) {
    width = args[1].parse!int();
    height = args[2].parse!int();
  }

  timer.start();
  writeln("working");
  pathCount = countLatticePaths(width, height);
  timer.stop();
  writeln(pathCount);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

ulong countLatticePaths(int width, int height) {
  enum {RIGHT, DOWN}
  ulong rightCount, downCount, pathCount;

  void takePath(int direction) {
    if (direction == RIGHT)
      rightCount++;

    else if (direction == DOWN)
      downCount++;

    if (rightCount < width)
      takePath(RIGHT);
    if (downCount < height)
      takePath(DOWN);

    if (rightCount == width && downCount == height)
      pathCount++;

    if (direction == RIGHT)
      rightCount--;

    if (direction == DOWN)
      downCount--;

    return;
  }

  takePath(RIGHT);
  takePath(DOWN);

  return pathCount;
}
