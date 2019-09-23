#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.functional;

enum {RIGHT, DOWN}

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
  int rightCount, downCount;
  ulong pathCount;

  pathCount += memoize!takePath(RIGHT, width, height, 0, 0);
  pathCount += memoize!takePath(DOWN, width, height, 0, 0);

  return pathCount;
}

ulong takePath(int direction, int width, int height, int rightCount, int downCount) {
  ulong pathCount, rightPathCount;

  if (direction == RIGHT)
    rightCount++;

  else if (direction == DOWN)
    downCount++;

  if (rightCount < width) {
    rightPathCount = memoize!takePath(RIGHT, width, height, rightCount, downCount);
    pathCount += rightPathCount;
  }
  if (downCount < height) {
    if (width - rightCount == height - downCount) {
      pathCount += rightPathCount;
    } else {
      pathCount += memoize!takePath(DOWN, width, height, rightCount, downCount);
    }
  }

  if (rightCount == width && downCount == height)
    pathCount++;

  if (direction == RIGHT)
    rightCount--;

  if (direction == DOWN)
    downCount--;

  return pathCount;
}
