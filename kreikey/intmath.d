module kreikey.intmath;

import kreikey.bigint;
import std.algorithm;
import std.stdio;
import std.traits;
import kreikey.primes;
import std.range;
import std.math;
import std.conv;
import std.typecons;
import std.functional;
import kreikey.bytemath;
import kreikey.stack;
import kreikey.digits;

alias primeFactors = memoize!primeFactors2;
alias distinctPrimeFactors = memoize!distinctPrimeFactors2;

long[] properDivisors(long number) {
  static long[][long] factorsCache;
  long[] factors;
  long[] factorsBig;
  long big = number;
  long fac = 1;
  long temp;

  if (number in factorsCache)
    return factorsCache[number];

  factors ~= fac;
  fac++;

  while (fac < big) {
    if (number % fac == 0) {
      factors ~= fac;
      big = number / fac;
      if (fac != big)
        factorsBig ~= big;
    }
    fac++;
  }

  std.algorithm.reverse(factorsBig);
  factors ~= factorsBig;
  factorsCache[number] = factors;

  return factors;
}

ulong mulOrder(ulong a, ulong n) {
  ulong order = 1;
  auto product = BigInt(a);
  auto one = BigInt(1);
  auto y = BigInt(a);
  auto z = BigInt(n);

  while (product % z != one) {
    order++;
    product *= y;
  }

  return order;
}

ulong carmichael(ulong n) {
  ulong a = 2;
  ulong order = 1;
  ulong bigOrder = 1;

  while (a < n) {
    if (areCoprime(a, n)) {
      order = mulOrder(a, n);

      if (order > bigOrder)
        bigOrder = order;
    }

    a++;
  }

  return bigOrder;
}

bool areCoprime(ulong a, ulong b) {
  return gcd(a, b) == 1;
}

// gcd with subtraction is about twice as fast as gcd with modulo
ulong gcd(ulong a, ulong b) {
  ulong t;

  while (b != a) {
    if (a > b)
      a -= b;
    else
      b -= a;
  }

  return b;
}

ulong lcm(ulong a, ulong b) {
  ulong amul = a;
  ulong bmul = b;

  while (amul != bmul) {
    if (amul < bmul)
      amul += a;
    else if (bmul < amul)
      bmul += b;
  }

  return amul;
}

string recipDigits(int divisor, int length) {
  int dividend = 10;
  int quotient = 0;
  int remainder = 0;
  int digitCount = 0;
  ubyte[] digits;

  do {
    quotient = dividend / divisor;
    remainder = dividend % divisor;
    dividend = remainder * 10;
    digits ~= cast(ubyte)quotient;
    digitCount++;
  } while (remainder != 0 && digitCount != length);

  digits[] += '0';

  return cast(string)digits;
}

ulong[] primeFactors2(ulong num) {
  ulong[] factors;
  ulong n = 2;

  if (num == 1)
    return [];

  while (num % n != 0)
    n++;

  if (num % n == 0)
    factors ~= n;

  return factors ~ memoize!primeFactors2(num / n);
}

ulong[] primeFactors1(ulong num) {
  ulong[] factors;
  ulong n = 2;

  while (num > 1) {
    while (num % n == 0) {
      factors ~= n;
      num /= n;
    }
    n++;
  }

  return factors;
}

ulong[] distinctPrimeFactors2(ulong num) {
  ulong[] factors;
  ulong n = 2;

  if (num == 1)
    return [];

  while (num % n != 0)
    n++;

  factors ~= n;

  while (num % n == 0)
    num /= n;

  return n ~ memoize!distinctPrimeFactors2(num);
}

ulong[] distinctPrimeFactors1(ulong num) {
  ulong[] factors;
  ulong n = 2;

  while (num > 1) {
    while (num % n != 0)
      n++;

    factors ~= n;

    while (num % n == 0)
      num /= n;
  }

  return factors;
}

struct Factor {
  int factor;
  int multiplicity;
}

Factor maxMultiplicity(Factor a, Factor b) {
  return a.multiplicity > b.multiplicity ? a : b;
}

auto isPrimeInit() {
  Primes!ulong primes = new Primes!ulong();

  bool isPrime(ulong number) {
    auto primesCopy = primes.save;

    if (number <= primesCopy.topPrime)
      return number in primesCopy.cache ? true : false;

    auto root = std.math.sqrt(real(number)).to!ulong();
    auto found = primesCopy.find!(p => number % p == 0 || p > root)().front;

    return found > root;
  }

  return &isPrime;
}

ulong factorial(ulong number) {
  ulong result = 1;

  if (number == 0)
    return result;

  for (size_t n = 1; n < number + 1; n++)
    result *= n;

  return result;
}

auto getTriplets(ulong perimeter) {
  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(ulong, ulong, ulong)[] triplets = [];
  ulong c = ceil(perimeter / pdiv).to!ulong();
  ulong b = ceil(real(perimeter - c) / 2).to!ulong();
  ulong a = perimeter - c - b;
  ulong csq = c ^^ 2;
  ulong absq = a ^^ 2 + b ^^ 2;

  do {
    if (absq == csq) {
      triplets ~= tuple(a, b, c);
    } else if (absq > csq) {
      c++;
      a--;
      csq = c ^^ 2;
    }
    b++;
    a--;
    absq = a ^^ 2 + b ^^ 2;
  } while (a > 0);

  return triplets;
}

auto maximizePower(Tuple!(ulong, ulong) source) {
  Tuple!(ulong, ulong) result;
  auto perfectPower = classifyPerfectPower(source[0]);
  result = tuple(perfectPower[0], perfectPower[1] * source[1]);
  return result;
}

auto classifyPerfectPower(ulong source) {
  Tuple!(ulong, ulong) result;

  if (source == 1) {
    result[0] = 1;
    result[1] = 1;
    return result;
  }

  auto primeFactorGroups = source.primeFactors.group.array();
  auto divisor = primeFactorGroups.map!(a => a[1]).fold!gcd();
  primeFactorGroups.each!((ref g) => g[1] /= divisor)();
  result[0] = primeFactorGroups
    .map!(a => a[0] ^^ a[1])
    .fold!((a, b) => a * b)();
  result[1] = divisor;

  return result;
}

Tuple!(ulong, ulong) reduceFrac(ulong numerator, ulong denominator) {
  ulong divisor = gcd(numerator, denominator);
  return tuple(numerator/divisor, denominator/divisor);
}

T isqrt(T)(T n, out T remainder)
if (isIntegral!T || is(T == BigInt)) {
  if (n == 0 || n == 1)
    return n;

  T minRoot = cast(T)pow(10, (countDigits(n) - 1) / 2);
  T minSq = n;
  T upperBound = n / 2 + 1;
  T delta = upperBound - minRoot;
  T halfDelta;
  T candidate;
  T candidateSq;

  do {
    halfDelta = delta / 2 + delta % 2;
    candidate = minRoot + halfDelta;
    candidateSq = candidate ^^ 2;
    if (candidateSq > n) {
      upperBound = candidate;
    } else {
      minRoot = candidate;
      minSq = candidateSq;
    }
    delta = upperBound - minRoot;
  } while (delta > 1);

  remainder = n - minSq;
  return minRoot;
}

T isqrt(T)(T n)
if (isIntegral!T || is(T == BigInt)) {
  T remainder;
  T root = isqrt(n, remainder);
  return root;
}

bool isSquare(T)(T n)
if (isIntegral!T || is(T == BigInt)) {
  T remainder;
  T root;

  root = sqrtInt(n, remainder);
  return remainder == 0;
}

auto squareRootSequence(T)(T number)
if (isIntegral!T || is(T == BigInt)) {
  T a0 = cast(T)sqrt(cast(real)number);
  T[] result;
  T a;
  T b = a0;
  T d = 1;
  T n = 1;
  T t;

  result ~= a0;

  do {
    d = number - b^^2;
    if (d == 0)
      break;
    d /= n;
    t = a0 + b;
    a = t / d;
    result ~= a;
    n = d;
    b = a0 - (t % d);
  } while (d != 1);

  return result;
}

auto continuedFraction(T, R)(R terms)
if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) && (isIntegral!T || is(T == BigInt))) {
  return ContinuedFraction!(R, T)(terms);
}

auto continuedFraction(R)(R terms)
if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R)) {
  return ContinuedFraction!(R)(terms);
}

struct ContinuedFraction(R, T = ElementType!R)
if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) && (isIntegral!T || is(T == BigInt))) {
  alias E = ElementType!R;
  E first;
  R range;
  static if (hasLength!R)
    alias Terms = typeof(only(first).chain(range.cycle()));
  else
    alias Terms = typeof(only(first).chain(range));
  Terms terms;
  size_t j = 0;
  enum bool empty = false;
  E[] cache;

  this(R _terms) {
    first = _terms.front;
    range = _terms.dropOne();
    static if (hasLength!R)
      terms = only(first).chain(range.cycle());
    else
      terms = only(first).chain(range);
  }

  auto front() @property {
    return this[j];
  }

  auto popFront() {
    j++;
  }

  Tuple!(T, T) opIndex(size_t i) {
    Tuple!(T, T) result = tuple(T(0), T(1));

    while (i >= cache.length) {
      cache ~= terms.front;
      terms.popFront();
    }

    foreach (item; cache.retro()) {
      result[0] = T(item) * result[1] + result[0];
      swap(result[0], result[1]);
    }

    swap(result[0], result[1]);

    return result;
  }
}

ulong totient(ulong number) {
  ulong[] factors = distinctPrimeFactors(number);

  ulong exclusiveMultiples(ulong factor, ulong[] moreFactors) {
    ulong multiples = (number - 1) / factor;
    ulong[] mask = new ulong[moreFactors.length];
    ulong mainFactor;
    ulong[] chosenFactors;
    ulong[] remainingFactors;

    void separate(out ulong[] chosenFactors, out ulong[] remainingFactors) {
      for (ulong i = 0; i < moreFactors.length; i++) {
        if (mask[i])
          chosenFactors ~= moreFactors[i];
        else
          remainingFactors ~= moreFactors[i];
      }
    }

    foreach (k; iota(0, mask.length).retro()) {
      mask[k..$] = 1;
      do {
        separate(chosenFactors, remainingFactors);
        mainFactor = factor * chosenFactors.fold!((a, b) => a * b)();
        multiples -= exclusiveMultiples(mainFactor, remainingFactors);
      } while (nextPermutation(mask));
      mask[] = 0;
    }

    return multiples;
  }

  return exclusiveMultiples(1, factors);
}
