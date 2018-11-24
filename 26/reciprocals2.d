module reciprocals2;

import std.algorithm;
import std.range;
import std.conv;
import std.stdio;
import std.array;

struct Reciprocal {
private:
  uint transientLength;
  uint reptendLength;

  void calcTransientReptend() {
    uint num = 10;
    uint quo;
    uint rem;
    uint savedRem;
    uint[] factors;
    uint transientLength;

    void popFront() {
      quo = num / denominator;
      rem = num % denominator;
      num = rem * 10;
    }

    void calcPrimeFactors(uint number) {
      uint n = 2;
      while (number > 1) {
        while (number % n == 0) {
          factors ~= n;
          number /= n;
        }
        n++;
      }
    }

    calcPrimeFactors(denominator);

    if (factors.any!(a => a == 2 || a == 5))
      transientLength = factors.filter!(a => a == 2 || a == 5).group.reduce!((a, b) => a[1] > b[1] ? a : b)[1];
    else
      transientLength = 0;

    popFront();

    foreach (i; 0 .. transientLength) {
      popFront();
      transient ~= cast(char)(quo + '0');
    }

    savedRem = rem;

    do {
      popFront();
      reptend ~= cast(char)(quo + '0');
    } while (rem != savedRem);
  }

public:
  uint denominator;
  string transient;
  string reptend;

  this(uint number) {
    this.denominator = number;
    this.calcTransientReptend();
  }

  string toString() {
    return "1/" ~ this.denominator.to!string;
  }
}

struct Reciprocals {
private:
  uint n = 1;

public:
  auto front = Reciprocal(1);

  enum empty = false;

  void popFront() {
    n++;
    front = Reciprocal(n);
  }

  typeof(this) save() @property {
    return this;
  }

  auto opSlice()(size_t i, size_t j) {
    auto that = this.save;

    foreach (n; 0 .. i)
      this.popFront();

    return that.take(j - i);
  }

  unittest {
    static assert(isForwardRange!(typeof(this)));
    static assert(isInfinite!(typeof(this)));
    static assert(hasSlicing!(typeof(this)));
  }
}
