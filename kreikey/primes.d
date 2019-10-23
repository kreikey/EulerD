module kreikey.primes;
import std.traits;
import std.stdio;

final class Primes(T)
if (isIntegral!T) {
private:
  T num;
  ulong ndx;
  static T root;
  static T nextSquare;
  static T[] primes;

  bool isPrime() {
    foreach (i; 0 .. primes.length) {
      if (primes[i] > root) {
        break;
      }
      if (num % primes[i] == 0) {
        return false;
      }
    }
    return true;
  }

public:
  static bool[T] cache = null;

  // ------- Constructors -------
  this() {
    primes.reserve(1000);
    num = 1;
    root = 1;
    nextSquare = (root + 1) ^^ 2;
    ndx = 0;
    popFront();
    cache[num] = true;
  }

  this(int initialCapacity) {
    primes.reserve(initialCapacity);
    num = 1;
    root = 1;
    nextSquare = (root + 1) ^^ 2;
    ndx = 0;
  }

  // ------- Range Primitives -------
  enum bool empty = false;

  void popFront() {
    if (ndx < primes.length) {
      num = primes[ndx++];
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
    if (primes.length == primes.capacity)
      primes.reserve(primes.capacity * 2);
    primes ~= num;
    cache[num] = true;
    ndx++;
  }

  T front() @property {
    return num;
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
    ndx = cast(T)primes.length;
    do {
      popFront();
    } while (ndx <= i);

    return num;
  }

  // ------- Other useful methods -------
  void reset() {
    num = 1;
    ndx = 0;
    popFront();
  }

  T topPrime() @property {
    return primes[$-1];
  }
}
