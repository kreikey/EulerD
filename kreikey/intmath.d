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
import std.concurrency;
import kreikey.bytemath;
import kreikey.stack;
import kreikey.digits;
import kreikey.combinatorics;

alias nextPermutation = kreikey.combinatorics.nextPermutation;
//alias nextPermutation = std.algorithm.nextPermutation;

T[] getAllFactors2(T)(T number) if (isIntegral!T) {
  auto factorGroups = getPrimeFactorGroups(number);
  bool[] mask = new bool[factorGroups.length];
  Tuple!(T, T)[] chosenFactorGroups;
  T[] result = [T(1)];

  T[] inner(Tuple!(T, T)[] myFactorGroups) {
    T product = 1;
    T[] result;
    T[] temp;

    if (myFactorGroups.length == 0)
      return [1];

    foreach (e; 1 .. myFactorGroups[0][1] + 1) {
      product *= myFactorGroups[0][0];

      // speed vs elegance
      temp = memoize!inner(myFactorGroups[1 .. $]).dup;
      temp[] *= product;
      result ~= temp;

      //result ~= memoize!inner(myFactorGroups[1 .. $])
        //.map!(a => a * product)
        //.array();
    }

    return result;
  }

  foreach (k; 1 .. mask.length + 1) {
    mask[] = true;
    mask[0 .. $ - k] = false;

    do {
      //chosenFactorGroups = factorGroups
        //.zip(mask)
        //.filter!(a => a[1])
        //.map!(a => a[0])
        //.array();

      // speed vs elegance
      chosenFactorGroups = [];
      for (int i = 0; i < factorGroups.length; i++)
        if (mask[i])
          chosenFactorGroups ~= factorGroups[i];

      result ~= memoize!inner(chosenFactorGroups);
    } while (mask.nextPermutation());
  }

  return result;
}

T[] getProperDivisors2(T)(T number) if (isIntegral!T) {
  return getAllFactors2(number)[0 .. $-1];
}

T[] getAllFactors(T)(T number) if (isIntegral!T) {
  static T[][T] factorsCache;
  T[] factors;
  T[] factorsBig;
  T big = number;
  T fac = 1;
  T temp;

  if (number in factorsCache)
    return factorsCache[number];

  do {
    if (number % fac == 0) {
      factors ~= fac;
      big = number / fac;
      if (fac != big)
        factorsBig ~= big;
    }
    fac++;
  } while (fac < big);

  std.algorithm.reverse(factorsBig);
  factors ~= factorsBig;
  factorsCache[number] = factors;

  return factors;
}

T[] getProperDivisors(T)(T number) if (isIntegral!T) {
  return getAllFactors(number)[0 .. $-1];
}

T countFactors1(T)(T num) if (isIntegral!T) {
  T count;
  T max = num;
  T fac = 1;

  if (num == 1)
    return 1;

  while (fac < max) {
    if (num % fac == 0) {
      count += 2;
      max = num / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  return count;
}

T countFactors2(T)(T num) 
if (isIntegral!T) {
  T count = 1;
  auto factorGroups = getPrimeFactorGroups(num);
  bool[] mask = new bool[factorGroups.length];

  foreach (k; 1 .. mask.length + 1) {
    mask[] = true;
    mask[0 .. $ - k] = false;

    do {
      count += factorGroups
        .zip(mask)
        .filter!(a => a[1])
        .map!(a => a[0][1])
        .reduce!((a, b) => a * b)();
    } while (mask.nextPermutation());
  }

  return count;
}

T mulOrder(T)(T a, T n) if (isIntegral!T) {
  T order = 1;
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

T carmichael(T)(T n) if (isIntegral!T) {
  T a = 2;
  T order = 1;
  T bigOrder = 1;

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

bool areCoprime(T)(T a, T b) if (isIntegral!T && !isSigned!T) {
  return gcd(a, b) == 1;
}

// gcd with subtraction is about twice as fast as gcd with modulo
T gcd(T)(T a, T b) if (isIntegral!T && !isSigned!T) {
  while (b != a) {
    if (a > b)
      a -= b;
    else
      b -= a;
  }

  return b;
}

T lcm(T)(T a, T b) if (isIntegral!T && !isSigned!T) {
  T amul = a;
  T bmul = b;

  while (amul != bmul) {
    if (amul < bmul)
      amul += a;
    else if (bmul < amul)
      bmul += b;
  }

  return amul;
}

T[] recipDigits(T = uint, U)(U divisor, size_t length) if (isIntegral!T && isIntegral!U && !isSigned!U) {
  U dividend = 10;
  U quotient = 0;
  U remainder = 0;
  U digitCount = 0;
  T[] digits;

  assert(divisor != 0);

  if (divisor == 1)
    return [];

  do {
    quotient = dividend / divisor;
    remainder = dividend % divisor;
    dividend = remainder * 10;
    digits ~= cast(T)quotient;
    digitCount++;
  } while (remainder != 0 && digitCount != length);

  return digits;
}

template getPrimeFactorGroups(T) if (isIntegral!T && !isSigned!T) {
  Tuple!(T, T)[] getPrimeFactorGroups(T num) {
    Tuple!(T, T)[] inner(T num) {
      T n = 2;
      T count = 0;
      Tuple!(T, T)[] result;

      if (num == 1)
        return result;

      while (num % n != 0)
        n++;

      while (num % n == 0) {
        num /= n;
        count++;
      }

      return [tuple(n, count)] ~ memoize!inner(num);
    }

    assert(num != 0);
    return memoize!inner(num);
  }
}

T[] getPrimeFactors(T)(T num) if (isIntegral!T && !isSigned!T) {
  T[] inner(T num) {
    T n = 2;

    if (num == 1)
      return [];

    while (num % n != 0)
      n++;

    return [n] ~ memoize!inner(num / n);
  }

  return memoize!inner(num);
}

T[] primeFactors1(T)(T num) if (isIntegral!T && !isSigned!T) {
  T[] factors;
  T n = 2;

  while (num > 1) {
    while (num % n == 0) {
      factors ~= n;
      num /= n;
    }
    n++;
  }

  return factors;
}

T[] getDistinctPrimeFactors(T)(T num) if (isIntegral!T && !isSigned!T) {
  T[] inner(T num) {
    T n = 2;

    if (num == 1)
      return [];

    while (num % n != 0)
      n++;

    while (num % n == 0)
      num /= n;

    return [n] ~ memoize!inner(num);
  }

  return memoize!inner(num);
}


T[] distinctPrimeFactors1(T)(T num) if (isIntegral!T && !isSigned!T) {
  T[] factors;
  T n = 2;

  while (num > 1) {
    while (num % n != 0)
      n++;

    factors ~= n;

    while (num % n == 0)
      num /= n;
  }

  return factors;
}

//struct Factor {
  //int factor;
  //int multiplicity;
//}

//Factor maxMultiplicity(Factor a, Factor b) {
  //return a.multiplicity > b.multiplicity ? a : b;
//}

T factorial(T)(T number) if (isIntegral!T && isUnsigned!T) {
  T result = 1;

  if (number == 0)
    return result;

  for (size_t n = 1; n < number + 1; n++)
    result *= n;

  return result;
}

auto getTriplets(T)(T perimeter) if (isIntegral!T && !isSigned!T) {
  enum real pdiv = sqrt(real(2)) + 1;
  Tuple!(T, T, T)[] triplets = [];
  T c = ceil(perimeter / pdiv).to!T();
  T b = ceil(real(perimeter - c) / 2).to!T();
  T a = perimeter - c - b;
  T csq = c ^^ 2;
  T absq = a ^^ 2 + b ^^ 2;

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

auto maximizePower(T)(Tuple!(T, T) source) if (isIntegral!T && !isSigned!T) {
  Tuple!(T, T) result;
  auto perfectPower = classifyPerfectPower(source[0]);
  result = tuple(perfectPower[0], perfectPower[1] * source[1]);
  return result;
}

auto classifyPerfectPower(T)(T source) if (isIntegral!T && !isSigned!T) {
  Tuple!(T, T) result;

  if (source == 1) {
    result[0] = 1;
    result[1] = 1;
    return result;
  }

  //auto primeFactorGroups = source.getPrimeFactors.group.array();
  auto primeFactorGroups = source.getPrimeFactorGroups();
  auto divisor = primeFactorGroups.map!(a => a[1]).fold!gcd();
  primeFactorGroups.each!((ref g) => g[1] /= divisor)();
  result[0] = primeFactorGroups
    .map!(a => a[0] ^^ a[1])
    .fold!((a, b) => a * b)();
  result[1] = divisor;

  return result;
}

auto reduceFrac(T)(T numerator, T denominator) if (isIntegral!T && !isSigned!T) {
  T divisor = gcd(numerator, denominator);
  return tuple(numerator/divisor, denominator/divisor);
}

T isqrt(T)(T n, out T remainder) if (isIntegral!T || is(T == BigInt)) {
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

T isqrt(T)(T n) if (isIntegral!T || is(T == BigInt)) {
  T remainder;
  T root = isqrt(n, remainder);
  return root;
}

bool isSquare(T)(T n) if (isIntegral!T || is(T == BigInt)) {
  T remainder;
  T root;

  root = sqrtInt(n, remainder);
  return remainder == 0;
}

auto squareRootSequence(T)(T number) if (isIntegral!T || is(T == BigInt)) {
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

auto continuedFraction(T, R)(R terms) if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) && (isIntegral!T || is(T == BigInt))) {
  return ContinuedFraction!(R, T)(terms);
}

auto continuedFraction(R)(R terms) if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R)) {
  return ContinuedFraction!(R)(terms);
}

struct ContinuedFraction(R, T = ElementType!R) if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) && (isIntegral!T || is(T == BigInt))) {
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

    foreach (item; cache[0 .. i+1].retro()) {
      result[0] = T(item) * result[1] + result[0];
      swap(result[0], result[1]);
    }

    swap(result[0], result[1]);

    return result;
  }
}

ulong getNonCoprimeCount(ulong[] factors) {
  bool[] mask = new bool[factors.length];
  ulong product = 0;
  ulong nonCoprimes = 0;
  ulong innerSum = 0;
  bool subtract = false;

  for (ulong k = 1; k <= mask.length; k++) {
    mask[] = false;
    mask[k .. $] = true;
    innerSum = 0;

    do {
      //product = zip(factors, mask).fold!((a, b) => tuple(b[1] ? a[0] * b[0] : a[0], true))(tuple(1uL, true))[0];
      product = zip(factors, mask).filter!(a => a[1]).map!(a => a[0]).fold!((a, b) => a * b)();
      innerSum += product;
    } while (nextPermutation(mask));

    if (subtract)
      nonCoprimes -= innerSum;
    else
      nonCoprimes += innerSum;

    subtract = !subtract;
  }

  return nonCoprimes;
}

ulong getTotient(ulong number) {
  auto factorGroups = getPrimeFactorGroups(number);
  //auto duplicateFactorProduct = factorGroups.fold!((a, b) => tuple(a[0] * b[0] ^^ (b[1] - 1), 1))(tuple(1uL, 1u))[0];
  auto duplicateFactorProduct = factorGroups.map!(a => a[0] ^^ (a[1] - 1)).fold!((a, b) => a * b);
  auto factors = factorGroups.map!(a => a[0]).array();
  ulong nonCoprimes = memoize!getNonCoprimeCount(factors);
  nonCoprimes *= duplicateFactorProduct;

  return number == 1 ? 1 : number - nonCoprimes;
}

ulong getTotientOld(ulong number) {
  ulong[] factors = getDistinctPrimeFactors(number);

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
      mask[] = 0;
      mask[k..$] = 1;
      do {
        separate(chosenFactors, remainingFactors);
        mainFactor = only(factor).chain(chosenFactors).fold!((a, b) => a * b)();
        multiples -= exclusiveMultiples(mainFactor, remainingFactors);
      } while (nextPermutation(mask));
    }

    return multiples;
  }

  if (number == 1)
    return 1uL;

  return exclusiveMultiples(1, factors);
}

ulong[] getCoprimes(ulong number) {
  ulong[] result;
  ulong[] factors = makePrimes
    .until!((a, b) => a >= b)(number)
    .setDifference(getDistinctPrimeFactors(number))
    .array();

  void inner(ulong product, ulong[] someFactors) {
    ulong nextProduct;

    result ~= product;

    foreach (i, f; someFactors) {
      nextProduct = product * f;

      if (nextProduct > number)
        break;

      inner(nextProduct, someFactors[i .. $]);
    }
  }

  inner(1, factors);

  return result;
}

auto getMultiTotientsInit(ulong topNumber) {
  void getMultiTotients() {
    ulong[] factors = makePrimes
      .until!((a, b) => a >= b)(topNumber)
      .array();

    void inner(ulong baseNumber, ulong multiplier, ulong[] someFactors, ulong[] distinctFactors) {
      ulong totient = multiplier * (baseNumber - memoize!getNonCoprimeCount(distinctFactors[1..$]));

      yield(tuple(ulong(baseNumber * multiplier), ulong(totient)));

      foreach (i, f; someFactors) {
        if (baseNumber * multiplier * f > topNumber)
          break;

        if (f == distinctFactors[$-1])
          inner(baseNumber, multiplier * f, someFactors[i .. $], distinctFactors);
        else
          inner(baseNumber * f, multiplier, someFactors[i .. $], distinctFactors ~ f);
      }
    }

    inner(1, 1, factors, [1]);
  }

  return &getMultiTotients;
}

auto getSortedDigitsInit(ulong lowerUpper) {
  return getSortedDigitsInit(lowerUpper, lowerUpper);
}

auto getSortedDigitsInit(ulong lower, ulong upper) {
  assert(lower <= upper);
  uint[] digits;

  void getSortedDigits() {
    void inner(size_t index, uint start) {
      if (index == digits.length)
        return;

      foreach (d; start .. 10u) {
        inner(index + 1, d);
        digits[index .. $] = d;
        yield(digits.dup);
      }
    }

    foreach (ulong s; lower .. upper + 1) {
      digits = new uint[s];
      digits[] = 0;
      inner(0, 1);
    }
  }

  return &getSortedDigits;
}
