#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.range;
import std.algorithm;
import std.conv;
import std.functional;
import kreikey.figurates;

void main() {
  foreach (n; 1 .. 51) {
    writef("p(%s): ", n);
    writeln(getCoefficients(n));
  }

  Pentagonals(1).take(10).writeln();
  Pentagonals(1).map!(a => a + 1).take(10).writeln();
}

int[] getCoefficients(int num) {
  int[] coefficients;

  void inner(int num, int limit) {
    foreach (l; iota(1, limit + 1).retro()) {
      if ((num - l) <= l) {
        //write("p", num - l, " ");
        if (coefficients.length < num - l + 1)
          coefficients.length = num - l + 1;
        coefficients[num - l]++;
      } else {
        //coefficients[] += inner(num - l, l)[];
        inner(num - l, l);
      }
    }
  }

  inner(num, num);
  //writeln();

  return coefficients;
}

uint countPartitionsWithSize(uint num, uint limit) {
  uint count = 0;

  if (num == 0 || num == 1 || limit == 1)
    return 1;

  foreach (n; num - limit .. num) {
    count = (count + memoize!countPartitionsWithSize(n, (num - n) > n ? n : (num - n))) % 1000000;
  }

  return count;
}

ulong countPartitions1(uint num) {
  ulong count = 0;

  void inner(uint[] numbers, uint total) {
    if (total >= num) {
      if (total == num) {
        //writeln(numbers);
        count++;
      }
      return;
    }

    for (uint n = numbers[$-1]; n > 0; n--) {
      inner(numbers ~ n, total + n);
    }
  }

  inner([num], 0);

  return count;
}
