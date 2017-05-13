#!/usr/bin/env rdmd

import std.stdio;
import std.conv;
import std.datetime;

void main() {
	StopWatch sw;
	long num = 0;
	long largestPal = 0;

	sw.start();
	foreach (int i; 100..1000) {
		foreach (int j; 100..1000) {
			num = i * j;
			if (num.isPalindrome() && num > largestPal)
				largestPal = num;			
		}
	}
	sw.stop();

	largestPal.writeln();
	writeln("finished in ", sw.peek.msecs(), " milliseconds");	
}

bool isPalindrome(long num) {
	string bleh = num.to!(string);

	if (bleh == bleh.dup.reverse)
		return true;
	else
		return false;
}