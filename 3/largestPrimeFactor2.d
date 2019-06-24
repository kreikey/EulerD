#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.algorithm;
import std.range;
import std.array;
import kreikey.primes;

// Another option would be something like:
// num.factors.filter!(isPrime).reduce!(max);

void main () {
  StopWatch sw;
  auto p = new Primes!long();
  long num = 600851475143;

  sw.start();

  auto equalsDividend = quotientCompareInit(num);
  p.until!(equalsDividend)(OpenRight.no).array()[$ - 1].writeln();

  sw.stop();

  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}

bool delegate(long) quotientCompareInit(long num) {
  long dividend = num;

  bool equalsDividend(long divisor) {
    if (dividend % divisor == 0) {
      dividend /= divisor;

      if (dividend <= divisor)
        return true;
    }

    return false;
  }

  return &equalsDividend;
}
