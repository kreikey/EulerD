module kreikey.primes;
import std.traits;
import std.stdio;
import std.stdio;
import std.format;

class Primes(T = ulong)
if (isIntegral!T) {
//private:
  size_t ndx;
  size_t offset;    // necessary for correct semantics for countUntil with opIndex. It should work like an array.
  static T root = 1;
  static T nextSquare = 4;
  static T[] primes = [2];

  bool isPrime(T num) {
    foreach (i; 0 .. primes.length) {
      if (primes[i] > root)
        break;
      if (num % primes[i] == 0)
        return false;
    }

    return true;
  }

public:
  static bool[T] cache = null;

  // ------- Constructors -------
  this() {
    //writeln("Primes.this");
    primes.reserve(1000);
    ndx = 0;
    offset = 0;
    cache[2] = true;
  }

  // ------- Range Primitives -------
  enum bool empty = false;

  void popFront() {
    //writeln("Primes.popFront");
    ndx++;

    if (ndx + offset < primes.length) {
      return;
    }

    T num = primes[$-1];

    do {
      num++;
      if (num == nextSquare) {
        root++;
        nextSquare = (root + 1) ^^ 2;
        num++;
      }
    } while (!isPrime(num));

    primes ~= num;
    cache[num] = true;
  }

  T front() @property {
    //writeln("Primes.front");
    return primes[ndx + offset];
  }

  typeof(this) save() @property {
    //writeln("Primes.save");
    auto ret = new typeof(this)();
    ret.ndx = this.ndx;
    ret.offset = this.offset;
    return ret;
  }

  T opIndex(size_t i) {
    //writeln("Primes.opIndex");
    if (i + offset < primes.length) {
      ndx = i;
      //writeln(ndx, " ", offset, " ", primes.length);
      return primes[ndx + offset];
    }

    ndx = primes.length - 1 - offset;

    do popFront();
    while (ndx + offset < i);

    return primes[ndx + offset];
  }

  // ------- Other useful methods -------
  void reset() {
    ndx = 0;
    offset = 0;
  }

  void reindex() {
    offset = ndx;
    ndx = 0;
  }

  T topPrime() @property {
    return primes[$-1];
  }

  override string toString() {
    return format("%s\t%s\t%s", ndx, root, nextSquare);
  }
}
