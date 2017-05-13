#!/usr/bin/env rdmd -I../

import std.stdio;
import simpleQueue;

void main() {
	SimpleQueue!int iq;
	iq.enqueue(10);
	iq.enqueue(6);
	iq.enqueue(88);
	writeln(iq.dequeue());
	writeln(iq.dequeue());
	writeln(iq.dequeue());
	writeln(iq.isEmpty());
}