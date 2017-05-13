#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.algorithm;
import std.range;
import std.array;
import kreikey.primes;
import kreikey.intmath;

void main () {
	StopWatch sw;
	Primes p = new Primes();
	long num = 600851475143;


	sw.start();

	// The ever-so-simple solution:
	writeln(num.primeFactors.reduce!(max));

	sw.stop();

	writeln("finished in ", sw.peek.msecs(), " milliseconds");
}