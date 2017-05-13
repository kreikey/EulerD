#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.array;
import std.conv;
import std.algorithm;

void main(string args[]) {
	int[] digits;
	char[] result;
	int dig, carryVal, n, sum, pow = 1000;

	if (args.length > 1) {
		pow = args[1].to!int;
	}
	StopWatch sw;


	sw.start();
	digits ~= 1;

	foreach (i; 0..pow) {
		foreach (j, x; digits) {
			dig = x * 2 + carryVal;

			if (dig > 9) {
				digits[j] = dig % 10;
				carryVal = dig / 10;
			} else {
				digits[j] = dig;
				carryVal = 0;
			}
		}
		if (carryVal) {
			digits ~= carryVal;
			carryVal = 0;
		}

		n = i + 1;
	}
	
	result = digits.map!(num => cast(char)(num + '0')).array.reverse;
	sum = digits.reduce!((a, b) => a + b);

	sw.stop();
	writefln("2^%s = %s", n, result);
	writefln("the sum of the digits is %s", sum);
	writefln("finished in %s milliseconds", sw.peek.msecs());
}
