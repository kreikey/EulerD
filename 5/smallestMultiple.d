#!/usr/bin/env rdmd

import std.stdio;
import std.conv;
import std.datetime;

void main(string args[]) {
	StopWatch sw;
	sw.start();
	int mul = 2;
	foreach (i; 3..21)
		mul = mul.lcm(i);
	sw.stop();
	writeln(mul);
	writeln("finished in ", sw.peek.msecs(), " milliseconds");
}

int lcm(int a, int b) {
	int mula = a, mulb = b;
	while (mula != mulb) {
		while (mula < mulb)
			mula += a;
		while (mulb < mula)
			mulb += b;
	}
	return mula;
}