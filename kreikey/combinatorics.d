module kreikey.combinatorics;

import kreikey.stack;
//import std.stdio;
import std.typecons;
import std.algorithm;

auto permutations(T)(ref T[] digits) {
  return Permutations!T(digits);
}

struct Permutations(T) {
  T[] digits;
  Stack!(Tuple!(size_t, size_t)) permStack;
  bool _empty = false;

  this(ref T[] _digits) {
    digits = _digits;
    fillStack(0);
  }

  T[] front() @property {
    return digits.dup;
  }

  void popFront() {
    if (permStack.empty) {
      _empty = true;
      return;
    }

    auto item = permStack.pop();
    auto ndx = item[0];
    auto offset = item[1];

    swap(digits[ndx], digits[$-1-offset]);

    fillStack(ndx + 1);
  }

  bool empty() @property {
    return _empty;
  }

  void fillStack(size_t ndx) {
    ulong window = digits.length - ndx;
    ulong offset = window - 2;

    while (window > 1) {
      permStack.push(tuple(ndx, window % 2 == 0 ? offset : 0));
      offset--;

      if (offset == ulong.max) {
        ndx++;
        window--;
        offset = window - 2;
      }
    } 
  }
}

bool nextPermutation(alias less = (a, b) => a < b, T)(ref T[] digits) {
  ulong i;
  ulong j;

  for (i = digits.length - 2; i < size_t.max; i--) {
    if (less(digits[i], digits[i + 1])) {
      break;
    }
  }

  if (i == size_t.max) {
    digits.sort!less();
    return false;
  }

  for (j = digits.length-1; j > i; j--) {
    if (!less(digits[j], digits[i]))
      break;
  }

  swap(digits[i], digits[j]);
  sort!less(digits[i+1..$]);

  return true;
}

T[] nthPermutation(T)(ref T[] digits, ulong n) {
  ulong count = 0;

  while (count++ < n) {
    digits.nextPermutation();
  }

  return digits;
}
