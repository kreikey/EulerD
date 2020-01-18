#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import kreikey.intmath;
import kreikey.bytemath;
import std.typecons;
import champernowne;

void main() {
  StopWatch timer;
  auto champ = Champernowne();
  auto champ2 = sequence!champernowne2();
  auto champ3 = sequence!champernowne3();
  assert(isRandomAccessRange!Champernowne);
  uint product = 1;

  timer.start();
  writeln("Champernowne's constant");

  foreach (e; 0..7) {
    product *= champ3[1 * 10 ^^ e];
  }

  timer.stop();

  writeln("the product of the digits of champernowne's constant,");
  writeln("d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000, is:");
  writeln(product);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

uint champernowne2(S)(S state, size_t nth) {
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

int champernowne3(S)(S state, size_t nth) {
  assert(nth > 0);
  ulong nIdx = nth - 1;

  alias InfIota = recurrence!((a, n) => a[n-1]+1, ulong);
  auto r1 = recurrence!((a, n) => a[n-1] * 10)(0uL, 9uL);
  auto r2 = r1.enumerate.map!(a => a[1] * a[0])();
  auto r3 = r1.cumulativeFold!((a, b) => a + b)();
  auto r4 = r2.cumulativeFold!((a, b) => a + b)();
  auto r5 = zip(InfIota(0uL), r3, r4).cache();

  auto theTail = r5.until!((h, n) => h[2] > n)(nIdx , OpenRight.no).tail(2).array();
  auto numDigs = theTail[1][0];
  ulong digsSub = theTail[0][2];
  ulong numAdd = theTail[0][1];
  ulong digInOrder = nIdx - digsSub;
  ulong theNumber = digInOrder / numDigs + numAdd + 1;
  ulong digIdx = digInOrder % numDigs;
  auto digits = theNumber.toDigits();

  return digits[digIdx];
}
