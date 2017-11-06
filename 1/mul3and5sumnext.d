#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime;
import std.algorithm;
import std.range;
import std.functional;
import std.conv;

// partial used to be called curry. This alias is no longer necessary, as sum works.
//alias partial!(std.algorithm.reduce!((a, b) => a + b), 0UL) addn;

void main(string[] args) {
	StopWatch sw;
	ulong limit = 1000;
	ulong result;

	if (args.length > 1)
		limit = args[1].parse!(ulong);

	sw.start();

	result = iota(1, limit).filter!(a => a % 3 == 0 || a % 5 == 0)
		.sum();
	
	//iota(3, limit, 3)
	//.setUnion(iota(5, limit, 5))
	//.uniq
	//.addn
	//.writeln();

	sw.stop();
	writeln("The sum multiples of 3 and 5 below ", limit, " is: ", result);
	writeln("finished in ", sw.peek.msecs(), " milliseconds.");
}

