#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.typecons;

void main() {
  StopWatch timer;

  timer.start();

  auto numerators = iota(10, 99).array();
  auto denominators = iota(11, 100).array();

  auto fractions = denominators
    .map!(a => numerators.until(a).map!(b => b, b => a)())
    .join
    .map!(a => toDigits(a[0]), a => toDigits(a[1]), a => tuple(a[0], a[1]))
    .filter!(a => (a[0][1] != 0 && a[1][1] != 0) && (a[0][0] != a[0][1] && a[1][0] != a[1][1]) && commonDigits(a.expand[0..2]))
    .map!(a => a[2], a => uniqueDigits(a.expand[0..2]))
    .filter!(a => reduceFrac(a[0]) == reduceFrac(a[1]))
    .array();

  writeln("Nontrivial digit cancelling fractions found: ", fractions.length);

  foreach (frac; fractions) {
    writefln("%(%s/%s%) = %(%s/%s%) = %(%s/%s%)", frac.expand, reduceFrac(frac[1]));
  }
  
  auto numerProduct = fractions
    .map!(a => a[0][0])
    .fold!((a, b) => a * b)();

  auto denomProduct = fractions
    .map!(a => a[0][1])
    .fold!((a, b) => a * b)();

  auto reducedFrac = reduceFrac(tuple(numerProduct, denomProduct));

  writefln("reduced product: %(%s/%s%)", reducedFrac);
  timer.stop();
  writefln("The product of denominators of these fractions in lowest terms is: %s", reducedFrac[1]);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds.");
}

// gcd with subtraction is about twice as fast as gcd with modulo
int gcd(int a, int b) {
  int t;

  while (b != a) {
    if (a > b)
      a = a - b;
    else
      b = b - a;
  }

  return b;
}

Tuple!(int, int) reduceFrac(Tuple!(int, int) f) {
  int divisor = gcd(f[0], f[1]);
  return tuple(f[0]/divisor, f[1]/divisor);
}

int[] toDigits(ulong source) {
  ulong maxPowTen = 1;
  int[] result;

  if (source == 0) {
    return [0];
  }

  while (maxPowTen <= source) {
    maxPowTen *= 10;
  } 

  maxPowTen /= 10;

  while (maxPowTen > 0) {
    result ~= cast(int)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
}

ulong toNumber(int[] digits) {
  ulong result = 0;

  int i = 0;
  foreach (n; digits.retro()) {
    result += n * 10 ^^ i;
    i++;
  }

  return result;
}

bool commonDigits(int[] numerator, int[] denominator) {
  foreach (d; numerator) {
    foreach (e; denominator) {
      if (d == e) {
        return true;
      }
    }
  }

  return false;
}

Tuple!(int, int) uniqueDigits(int[] numerator, int[] denominator) {
  int commonDigit = 0;

  foreach (d; numerator) {
    foreach (e; denominator) {
      if (d == e) {
        commonDigit = d;
      }
    }
  }

  int numeratorResult = numerator[0] != commonDigit ? numerator[0] : numerator[1];
  int denominatorResult = denominator[0] != commonDigit ? denominator[0] : denominator[1];

  return tuple(numeratorResult, denominatorResult);
}

