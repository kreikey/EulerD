#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.conv;
import std.parallelism;

void main(string args[]) {
	int width = 20, height = 20, pathCount;
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

int countLatticePaths(int width, int height) {
	enum {RIGHT, DOWN};
	int rightCount, downCount, pathCount;

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