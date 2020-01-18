#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;
import kreikey.intmath;
import kreikey.bytemath;

void main() {
  StopWatch timer;

  writeln("digit cancelling fractions");
  timer.start();

  auto fractions = iota(11, 100)
    .map!(a => iota(10, 99).until(a).map!(b => b, b => a)())
    .join
    .map!(a => a, a => tuple(toDigits(a[0]), toDigits(a[1])))
    .filter!(a => isNonTrivial(a[1].expand) && hasCommonDigits(a[1].expand))
    .map!(a => a[0], a => uniqueDigits(a[1].expand))
    .filter!(a => reduceFrac(a[0].expand) == reduceFrac(a[1].expand))
    .array();

  writeln("Nontrivial digit cancelling fractions found: ", fractions.length);

  foreach (frac; fractions)
    writefln("%(%s/%s%) = %(%s/%s%) = %(%s/%s%)", frac.expand, reduceFrac(frac[1].expand));
  
  auto product = fractions
    .map!(a => a[0])
    .fold!((a, b) => tuple(a[0] * b[0], a[1] * b[1]))(tuple(1, 1));

  auto reducedFrac = reduceFrac(product.expand);

  writefln("reduced product: %(%s/%s%)", reducedFrac);
  timer.stop();
  writefln("The product of denominators of these fractions in lowest terms is: %s", reducedFrac[1]);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

Tuple!(ulong, ulong) reduceFrac(ulong numerator, ulong denominator) {
  ulong divisor = gcd(numerator, denominator);
  return tuple(numerator/divisor, denominator/divisor);
}

bool hasCommonDigits(uint[] numerator, uint[] denominator) {
  foreach (d; numerator)
    foreach (e; denominator)
      if (d == e)
        return true;

  return false;
}

Tuple!(uint, uint) uniqueDigits(uint[] numerator, uint[] denominator) {
  uint commonDigit = 0;

  foreach (d; numerator)
    foreach (e; denominator)
      if (d == e)
        commonDigit = d;

  uint numeratorResult = numerator[0] != commonDigit ? numerator[0] : numerator[1];
  uint denominatorResult = denominator[0] != commonDigit ? denominator[0] : denominator[1];

  return tuple(numeratorResult, denominatorResult);
}

bool isNonTrivial(uint[] numerator, uint[] denominator) {
  bool hasMultipleOf10() {
    return numerator[1] == 0 || denominator[1] == 0;
  }

  bool hasMultipleOf11() {
    return numerator[0] == numerator[1] || denominator[0] == denominator[1];
  }

  return !hasMultipleOf10() && !hasMultipleOf11();
}
