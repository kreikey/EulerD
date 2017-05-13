#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.conv;
import std.parallelism;

enum {RIGHT, DOWN};

void main(string args[]) {
	int width = 20, height = 20;
	ulong pathCount;
	StopWatch sw;

	if (args.length > 2) {
		width = args[1].to!(int);
		height = args[2].to!(int);
	}

	sw.start();
	writeln("working");
	pathCount = countLatticePaths(width, height);
	sw.stop();
	writeln(pathCount);
	writefln("finished in %s milliseconds", sw.peek.msecs());
}

ulong countLatticePaths(int width, int height) {
	int rightCount, downCount;
	ulong pathCount;

/*	auto rightPathTask = task!takePath(RIGHT, width, height, 0, 0);
	rightPathTask.executeInNewThread();
	pathCount += takePath(DOWN, width, height, 0, 0);
	pathCount += rightPathTask.yieldForce();
*/

	if (width == height) {
		pathCount += 2 * takePath(RIGHT, width, height, 0, 0);		
	} else {
		pathCount += takePath(RIGHT, width, height, 0, 0);		
		pathCount += takePath(DOWN, width, height, 0, 0);		
	}

	return pathCount;
}

ulong takePath(int direction, int width, int height, int rightCount, int downCount) {
	ulong pathCount, rightPathCount;

	if (direction == RIGHT)
		rightCount++;

	else if (direction == DOWN)
		downCount++;

	if (rightCount < width) {
		rightPathCount = takePath(RIGHT, width, height, rightCount, downCount);
		pathCount += rightPathCount;
	}
	if (downCount < height) {
		if (width - rightCount == height - downCount) {
			pathCount += rightPathCount;
		} else {
			pathCount += takePath(DOWN, width, height, rightCount, downCount);
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
