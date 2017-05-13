#!/usr/bin/env rdmd -I..
import std.stdio;
import std.conv;
import std.datetime;
import std.algorithm;
import std.functional;
import kreikey.primes;

alias curry!(std.algorithm.reduce!((a, b) => a + b), 0UL) addn;

void main(string args[]) {
	StopWatch sw;
	Primes p = new Primes(1000);
	ulong limit = 2_000_000;
	ulong sum;

	if (args.length > 1)
		limit = args[1].parse!(ulong);

	sw.start();

	sum = p.until!((a, b) => a >= b)(limit).addn();

	sw.stop();

	writefln("The sum of all primes below %s is %s.", limit, sum);
	writefln("Finished in %s milliseconds.", sw.peek.msecs());
}