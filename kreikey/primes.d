module kreikey.primes;
import std.traits;
import std.stdio;

class Primes(T = ulong)
if (isIntegral!T) {
private:
  T num = 2;
  size_t ndx;
  static T root = 1;
  static T nextSquare = 4;
  static T[] primes = [2];

  bool isPrime() {
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
    primes.reserve(1000);
    num = 2;
    ndx = 0;
    cache[2] = true;
  }

  // ------- Range Primitives -------
  enum bool empty = false;

  void popFront() {
    ndx++;

    if (ndx < primes.length) {
      return;
    }

    do {
      num++;
      if (num == nextSquare) {
        root++;
        nextSquare = (root + 1) ^^ 2;
        num++;
      }
    } while (!isPrime());

    primes ~= num;
    cache[num] = true;
  }

  T front() @property {
    return primes[ndx];
  }

  typeof(this) save() @property {
    auto ret = new typeof(this)();
    ret.num = this.num;
    ret.ndx = this.ndx;
    return ret;
  }

  T opIndex(size_t i) {
    if (i < primes.length) {
      ndx = i;
      num = primes[ndx];
      return num;
    }

    num = primes[$ - 1];
    ndx = primes.length;

    do popFront();
    while (ndx <= i);

    return num;
  }

  // ------- Other useful methods -------
  void reset() {
    num = 2;
    ndx = 0;
  }

  T topPrime() @property {
    return primes[$-1];
  }
}
