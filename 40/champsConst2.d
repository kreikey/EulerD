#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import kreikey.digits;
import std.typecons;

void main() {
  StopWatch timer;
  auto champ = sequence!champernowne();
  uint product = 1;

  timer.start();
  writeln("Champernowne's constant");

  foreach (e; 0..7) {
    product *= champ[10 ^^ e];
  }

  timer.stop();

  writeln("the product of the digits of champernowne's constant,");
  writeln("d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000, is:");
  writeln(product);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

uint champernowne(S)(S state, size_t nth) {
  ulong digMul = 0;
  ulong decMul = 1;
  ulong chunk = 0;
  ulong numID = 0;
  ulong digID = 0;
  ulong sum = 0;
  ulong digSum = 0;
  ulong digChunk = 0;
  uint[] digits;

  assert(nth > 0);
  nth--;

  do {
    digMul++;
    chunk = 9 * decMul;
    sum += chunk;
    digChunk = chunk * digMul;
    digSum += digChunk;
    decMul *= 10;
  } while (digSum < nth);

  digSum -= digChunk;
  nth -= digSum;
  sum -= chunk;
  numID = nth / digMul + sum + 1;
  digID = nth % digMul;
  digits = numID.toDigits();

  return digits[digID];
}
