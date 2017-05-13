#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.array;
import std.conv;
import std.algorithm;
import Shared.bigInt;

void main(string args[]) {
	StopWatch sw;
	int[] digits = "100".dup.toReverseIntArr();
	int[] result;
	char[] resultString; 
	char[] digitsString;
	int offset = 0;
	int sum;

	if (args.length > 1) {
		digits = args[1].dup.toReverseIntArr();
	}

	sw.start();

	result = factorial(digits);
	resultString = result.toReverseCharArr();
	digitsString = digits.toReverseCharArr();
	sum = result.reduce!((a, b) => a + b);

	sw.stop();

	writefln("The factorial of %s is:\n%s", digitsString, resultString);
	writefln("the sum of the digits is %s", sum);
	writefln("finished in %s milliseconds", sw.peek.msecs());
}
