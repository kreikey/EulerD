#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.algorithm;
import std.range;
import std.datetime.stopwatch;
import kreikey.digits;
import std.typecons;

struct Champernowne {
  private:
    uint[] digits = [1];
    ulong topNum = 1;
    size_t fidx = 0;

  public:
    enum bool empty = false;

    uint front() @property {
      return digits[fidx];
    }

    void popFront() {
      fidx++;
      if (fidx > digits.length - 1) {
        topNum++;
        digits ~= topNum.toDigits();
      }
    }

    typeof(this) save() @property {
      typeof(this) copy;

      copy.digits = this.digits.dup;
      copy.topNum = this.topNum;
      copy.fidx = this.fidx;

      return copy;
    }

    uint opIndex(size_t idx) {
      while ((idx - 1) >= digits.length)
        this.popFront;
      return digits[idx - 1];
    }
}

void main() {
  StopWatch timer;
  auto champ = Champernowne();
  assert(isRandomAccessRange!Champernowne);
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
