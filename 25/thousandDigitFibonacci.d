#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.array;
import std.conv;
import std.algorithm;
import std.range;
import kreikey.bigint;

void main(string[] args) {
  StopWatch sw;
  byte[] result;
  byte[] addend1;
  byte[] addend2;
  int limit = 1000;
  int term = 2;

  if (args.length > 1) {
    limit = args[1].parse!int;
  }

  sw.start();
  addend1 = "1".rbytes;
  addend2 = "1".rbytes;
  
  while (result.length < limit) {
    result = add(addend1, addend2);
    addend1 = addend2;
    addend2 = result;
    term++;
  }
  sw.stop();

  writefln("the first %s-digit fibonacci term is number %s.", limit, term);
  writefln("the term is:\n%s", result.rstr);
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}

byte[] rbytes(string value) {
  return value.retro.map!(a => cast(byte)(a - '0')).array();
}

string rstr(const byte[] value) {
  return value.retro.map!(a => cast(immutable(char))(a + '0')).array();
}

char[] toReverseCharArr(byte[] arr) {
  return arr.retro.map!(a => cast(char)(a + '0')).array();
}

byte[] add(const(byte)[] left, const(byte)[] right) {
  const(byte)[] temp;

  if (right.length > left.length) {
    temp = left;
    left = right;
    right = temp;
  }

  byte[] result = left.dup;
  byte carry = 0;

  foreach (ref a, b; lockstep(result, right)) {
    a += b + carry;
    carry = a / 10;
    a %= 10;
  }
  foreach (ref a; result[right.length .. $]) {
    a += carry;
    carry = a / 10;
    a %= 10;
  }
  if (carry)
    result ~= carry;

  return result;
}
