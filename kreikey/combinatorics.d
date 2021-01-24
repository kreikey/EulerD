module kreikey.combinatorics;

import kreikey.stack;
import std.stdio;
import std.typecons;
import std.algorithm;
import std.range;
import std.functional;
import kreikey.bigint;
import std.traits;
import std.experimental.checkedint;

auto permutations(T)(T[] digits) {
  return Permutations!T(digits);
}

struct Permutations(T) {
  T[] digits;
  Stack!(Tuple!(size_t, size_t)) permStack;
  bool _empty = false;

  this(T[] _digits) {
    digits = _digits.dup;
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
    foreach (i; iota(1, digits.length-ndx).retro())
      foreach (j; iota(i).retro())
        permStack.push(tuple(digits.length-1-i, (i+1)%2 == 0 ? j : 0));
  }
}

bool nextPermutation(alias less = (a, b) => a < b, T)(ref T[] digits) {
  ulong i;
  ulong j;

  for (i = digits.length - 2; i < size_t.max; i--) {
    if (less(digits[i], digits[i+1]))
      break;
  }

  if (i == size_t.max) {
    digits.sort!less();
    return false;
  }

  for (j = digits.length-1; j > i; j--) {
    if (!(less(digits[j], digits[i]) || digits[j] == digits[i]))
      break;
  }

  swap(digits[i], digits[j]);
  sort!less(digits[i+1..$]);

  return true;
}

T[] nthPermutation(T)(ref T[] digits, ulong n) {
  ulong count = 0;

  while (count++ < n)
    digits.nextPermutation();

  return digits;
}

bool isPermutation(T)(T[] left, T[] right) {
  import kreikey.util: asort;
  return left.dup.asort() == right.dup.asort();
}

bool isPermutation(T)(T left, T right)
if (isIntegral!T || is(T == BigInt)) {
  import kreikey.digits: toDigits;
  return isPermutation(left.toDigits, right.toDigits);
}

T nChooseK(T)(T n, T k)
if (isIntegral!T || is(T == BigInt)) {
  alias NK = Tuple!(T, "n", T, "k");
  static if (is(T == BigInt) || isSigned!T)
    alias keepSumming = (NK left, NK right) => (left.k >= 0 && right.k <= right.n);
  else
    alias keepSumming = (NK left, NK right) => (left.k < T.max && right.k <= right.n);

  assert(k <= n);

  if (k == 0 || k == n)
    return T(1);

  NK left = tuple(k, k);
  NK right = tuple(n - k, 0);
  static if (is(T == BigInt))
    T sum = 0;
  else
    auto sum = checked!Throw(T(0));
  T leftSum;
  T rightSum;
  T product;

  do {
    leftSum = memoize!(nChooseK!T)(left.n, left.k);
    rightSum = memoize!(nChooseK!T)(right.n, right.k);
    static if (is(T == BigInt))
      product = leftSum * rightSum;
    else
      product = (checked!Throw(leftSum) * rightSum).get;
    sum += product;
    left.k--;
    right.k++;
  } while (keepSumming(left, right));

  static if (is(T == BigInt))
    return sum;
  else
    return sum.get;
}

int countPermutations(uint[] source) {
  import kreikey.intmath : factorial;

  return (cast(int)source.length).factorial();
}

int countNumberPermutations(uint[] source) {
  int nonZeroCount = cast(int)source.filter!(a => a != 0).count();

  return source.countPermutations() * nonZeroCount / cast(int)source.length;
}

int countDistinctPermutations(uint[] source) {
  import kreikey.intmath : factorial;

  auto groups = source.group.array();
  int numerator = (cast(int)source.length).factorial();
  int denominator = groups.map!(a => a[1].factorial()).fold!((a, b) => a * b);
  int basicCount = numerator / denominator;

  return basicCount;
}

int countDistinctNumberPermutations(uint[] source) {
  int nonZeroCount = cast(int)source.filter!(a => a != 0).count();

  return source.countDistinctPermutations() * nonZeroCount / cast(int)source.length;
}
