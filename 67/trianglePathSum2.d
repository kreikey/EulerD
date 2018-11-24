#!/usr/bin/env rdmd -I../
import std.stdio;
import std.datetime;
import std.conv;
import std.array;
import std.algorithm;

void main(string args[]) {
	StopWatch sw;
	int[][] triangle;
	File inFile;
	string fileName = "triangle.txt";
	int sum, sumA, sumB;

	if (args.length > 1) {
		fileName = args[1];
	}

	sw.start();
	inFile = File(fileName);
	triangle = inFile.byLine.map!(line => line.split(" ").map!(numstr => numstr.parse!(int)).array).array();

	foreach_reverse (ulong y, triRow; triangle) {
		foreach (ulong x, triCell; triRow[0..$-1]) {
			triangle[y - 1][x] += triCell > triRow[x + 1] ? triCell : triRow[x + 1];
		}
	}

	sum = triangle[0][0];
	writeln(sum);
	sw.stop();
	writefln("finished in %s milliseconds", sw.peek.msecs());
}
