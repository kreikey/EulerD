module reciprocals;

import std.algorithm;
import std.range;
import std.conv;
import std.stdio;

struct Reciprocal {
private:
  uint[] factors;
  uint transientLength;
  uint reptendLength;

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

  void calcTransientLength() {
    if (this.hasTransient)
      transientLength = factors.filter!(isTwoOrFive).group.reduce!((a, b) => a[1] > b[1] ? a : b)[1];
    else
      transientLength = 0;
  }

  void calcReptendLength() {
    uint n;
    uint count;

    if (this.isRepeating == false)
      reptendLength = 0;

    else {
      auto rems = this.remainders();
      rems.popFrontN(transientLength);
      n = rems.front;

      do {
        this.reptendLength++;
        rems.popFront();
      } while(rems.front != n);
    }
  }

  void calcTransient() {
    transient = this.digits[0 .. transientLength]
      .map!(a => cast(immutable(char))(a + '0')).array();
  }

  void calcReptend() {
    reptend = this.digits[transientLength .. transientLength + reptendLength]
      .map!(a => cast(immutable(char))(a + '0')).array();
  }

public:
  uint denominator;
  string transient;
  string reptend;

  this(uint number) {
    this.denominator = number;
    this.calcPrimeFactors(number);
    this.calcTransientLength();
    this.calcReptendLength();
    this.calcTransient();
    this.calcReptend();
  }

  bool isRepeating() @property {
    return factors.any!(isNotTwoOrFive);
  }

  bool hasTransient() @property {
    return factors.any!(isTwoOrFive);
  }

  //string transient() @property {
  //  return digits[0 .. transientLength]
  //    .map!(a => cast(immutable(char))(a + '0')).array();
  //}

  //string reptend() @property {
  //  return digits[transientLength .. transientLength + reptendLength]
  //    .map!(a => cast(immutable(char))(a + '0')).array();
  //}

  auto digits() @property {
    struct Result {
      uint num;
      uint denom;
      uint quo;
      uint rem;

      this(uint n) {
        num = 10;
        denom = n;
        popFront();
      }

      // ------- Range Primitives -------

      enum empty = false;

      void popFront() {
        quo = num / denom;
        rem = num % denom;
        num = rem * 10;
      }

      uint front() @property {
        return quo;
      }

      typeof(this) save() @property {
        return this;
      }

      // ------- Overloaded Operators -------

      auto opSlice()(size_t i, size_t j) {
        foreach (n; 0 .. i)
          this.popFront();

        return this.take(j - i);
      }
    }

    return Result(this.denominator);
  }

  unittest {
    static assert(isForwardRange!(typeof(this.digits)));
    static assert(isInfinite!(typeof(this.digits)));
    static assert(hasSlicing!(typeof(this.digits)));
  }

  auto remainders() @property {
    struct Result {
      uint num;
      uint denom;
      uint quo;
      uint rem;

      this(uint n) {
        num = 10;
        denom = n;
        popFront();
      }

      // ------- Range Primitives -------

      enum empty = false;

      uint front() @property {
        return rem;
      }

      void popFront() {
        quo = num / denom;
        rem = num % denom;
        num = rem * 10;
      }

      typeof(this) save() @property {
        return this;
      }

      // ------- Overloaded Operators -------

      auto opSlice()(size_t i, size_t j) {
        foreach (n; 0 .. i)
          this.popFront();

        return this.take(j - i);
      }
    }

    return Result(this.denominator);
  }

  unittest {
    static assert(isForwardRange!(typeof(this.remainders())));
    static assert(isInfinite!(typeof(this.remainders())));
    static assert(hasSlicing!(typeof(this.remainders())));
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
      that.popFront();

    return that.take(j - i);
  }

  unittest {
    static assert(isForwardRange!(typeof(this)));
    static assert(isInfinite!(typeof(this)));
    static assert(hasSlicing!(typeof(this)));
  }
}

bool isTwoOrFive(uint n) {
  return n == 2 || n == 5;
}

bool isNotTwoOrFive(uint n) {
  return !(n == 2 || n == 5);
}

