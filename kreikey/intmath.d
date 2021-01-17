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
alias getPrimeFactors = getPrimeFactors2;
alias getDistinctPrimeFactors = getDistinctPrimeFactors2;
alias getFactors = getFactors2;
alias getProperDivisors = getProperDivisors2;
alias countFactors = countFactors2;
alias getPrimeFactorGroups = getPrimeFactorGroups2;

T[] getFactors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

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

    foreach (e; 1 .. myFactorGroups[0][1]+1) {
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

  foreach (k; 1 .. mask.length+1) {
    mask[] = true;
    mask[0 .. $-k] = false;

    do {
      // speed vs elegance
      chosenFactorGroups = [];
      for (size_t i = 0; i < factorGroups.length; i++)
        if (mask[i])
          chosenFactorGroups ~= factorGroups[i];

      //chosenFactorGroups = factorGroups
        //.zip(mask)
        //.filter!(a => a[1])
        //.map!(a => a[0])
        //.array();

      result ~= memoize!inner(chosenFactorGroups);
    } while (mask.nextPermutation());
  }

  return result;
}

T[] getFactors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

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

T[] getProperDivisors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  return getFactors2(number)[0 .. $-1];
}

T[] getProperDivisors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  return getFactors(number)[0 .. $-1];
}

T countFactors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T count = 1;
  auto factorGroups = getPrimeFactorGroups(number);
  bool[] mask = new bool[factorGroups.length];

  foreach (k; 1 .. mask.length+1) {
    mask[] = true;
    mask[0 .. $-k] = false;

    do {
      count += factorGroups
        .zip(mask)
        .filter!(a => a[1])
        .map!(a => a[0][1])
        .fold!((a, b) => a * b)();
    } while (mask.nextPermutation());
  }

  return count;
}

T countFactors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T count;
  T max = number;
  T fac = 1;

  if (number == 1)
    return 1;

  while (fac < max) {
    if (number % fac == 0) {
      count += 2;
      max = number / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  return count;
}

T mulOrder(T)(T a, T n) if (isIntegral!T) {
  assert (a > 0 && n > 0);

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

T carmichael(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T a = 2;
  T order = 1;
  T bigOrder = 1;

  while (a < number) {
    if (areCoprime(a, number)) {
      order = mulOrder(a, number);

      if (order > bigOrder)
        bigOrder = order;
    }

    a++;
  }

  return bigOrder;
}

bool areCoprime(T)(T a, T b) if (isIntegral!T) {
  assert (a > 0 && b > 0);

  return gcd(a, b) == 1;
}

// gcd with subtraction is about twice as fast as gcd with modulo
T gcd(T)(T a, T b) if (isIntegral!T) {
  assert (a > 0 && b > 0);

  while (b != a) {
    if (a > b)
      a -= b;
    else
      b -= a;
  }

  return b;
}

T lcm(T)(T a, T b) if (isIntegral!T) {
  assert (a > 0 && b > 0);

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

int[] recipDigits(T)(T divisor, size_t length) if (isIntegral!T) {
  assert (divisor > 0);

  T dividend = 10;
  T quotient = 0;
  T remainder = 0;
  T digitCount = 0;
  int[] digits;

  if (divisor == 1)
    return [];

  do {
    quotient = dividend / divisor;
    remainder = dividend % divisor;
    dividend = remainder * 10;
    digits ~= cast(int)quotient;
    digitCount++;
  } while (remainder != 0 && digitCount != length);

  return digits;
}

Tuple!(T, T)[] getPrimeFactorGroups2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T n = 2;
  T count = 0;
  Tuple!(T, T)[] result;

  if (number == 1)
    return result;

  while (number % n != 0)
    n++;

  while (number % n == 0) {
    number /= n;
    count++;
  }

  return [tuple(n, count)] ~ memoize!(getPrimeFactorGroups2!T)(number);
}

Tuple!(T, T)[] getPrimeFactorGroups1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T n = 2;
  T count = 0;
  Tuple!(T, T)[] result;

  while (number > 1) {
    while (number % n != 0) {
      n++;
    }
    while (number % n == 0) {
      number /= n;
      count++;
    }
    result ~= tuple(n, count);
    count = 0;
  }

  return result;
}

T[] getPrimeFactors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T n = 2;

  if (number == 1)
    return [];

  while (number % n != 0)
    n++;

  return [n] ~ memoize!(getPrimeFactors2!T)(number / n);
}

T[] getPrimeFactors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T[] factors;
  T n = 2;

  while (number > 1) {
    while (number % n == 0) {
      factors ~= n;
      number /= n;
    }
    n++;
  }

  return factors;
}

T[] getDistinctPrimeFactors2(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T n = 2;

  if (number == 1)
    return [];

  while (number % n != 0)
    n++;

  while (number % n == 0)
    number /= n;

  return [n] ~ memoize!(getDistinctPrimeFactors2!T)(number);
}


T[] distinctPrimeFactors1(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T[] factors;
  T n = 2;

  while (number > 1) {
    while (number % n != 0)
      n++;

    factors ~= n;

    while (number % n == 0)
      number /= n;
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

T factorial(T)(T number) if (isIntegral!T) {
  assert (number >= 0);

  T result = 1;

  if (number == 0)
    return result;

  for (size_t n = 1; n < number + 1; n++)
    result *= n;

  return result;
}

auto getTriplets(T)(T perimeter) if (isIntegral!T) {
  assert (perimeter > 0);

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

auto maximizePower(T)(Tuple!(T, T) number) if (isIntegral!T) {
  assert (number > 0);

  Tuple!(T, T) result;
  auto perfectPower = classifyPerfectPower(number[0]);
  result = tuple(perfectPower[0], perfectPower[1] * number[1]);
  return result;
}

auto classifyPerfectPower(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  Tuple!(T, T) result;

  if (number == 1) {
    result[0] = 1;
    result[1] = 1;
    return result;
  }

  //auto primeFactorGroups = number.getPrimeFactors.group.array();
  auto primeFactorGroups = number.getPrimeFactorGroups();
  auto divisor = primeFactorGroups.map!(a => a[1]).fold!gcd();
  primeFactorGroups.each!((ref g) => g[1] /= divisor)();
  result[0] = primeFactorGroups
    .map!(a => a[0] ^^ a[1])
    .fold!((a, b) => a * b)();
  result[1] = divisor;

  return result;
}

auto reduceFrac(T)(T numerator, T denominator) if (isIntegral!T) {
  assert (numerator >= 0 && denominator > 0);

  T divisor = gcd(numerator, denominator);
  return tuple(numerator/divisor, denominator/divisor);
}

T isqrt(T)(T number, out T remainder) if (isIntegral!T || is(T == BigInt)) {
  assert (number >= 0);

  if (number == 0 || number == 1)
    return number;

  T minRoot = cast(T)pow(10, (countDigits(number) - 1) / 2);
  T minSq = number;
  T upperBound = number / 2 + 1;
  T delta = upperBound - minRoot;
  T halfDelta;
  T candidate;
  T candidateSq;

  do {
    halfDelta = delta / 2 + delta % 2;
    candidate = minRoot + halfDelta;
    candidateSq = candidate ^^ 2;
    if (candidateSq > number) {
      upperBound = candidate;
    } else {
      minRoot = candidate;
      minSq = candidateSq;
    }
    delta = upperBound - minRoot;
  } while (delta > 1);

  remainder = number - minSq;
  return minRoot;
}

T isqrt(T)(T number) if (isIntegral!T || is(T == BigInt)) {
  assert (number > 0);

  T remainder;
  T root = isqrt(number, remainder);

  return root;
}

bool isSquare(T)(T number) if (isIntegral!T || is(T == BigInt)) {
  assert (number > 0);

  T remainder;
  T root = sqrtInt(number, remainder);

  return remainder == 0;
}

auto squareRootSequence(T)(T number) if (isIntegral!T || is(T == BigInt)) {
  assert (number > 0);

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

T getNonCoprimeCount(T)(T[] factors) if (isIntegral!T) {
  bool[] mask = new bool[factors.length];
  T product = 0;
  T nonCoprimes = 0;
  T innerSum = 0;
  bool subtract = false;

  for (T k = 1; k <= mask.length; k++) {
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

T getTotient(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  auto factorGroups = getPrimeFactorGroups(number);
  //auto duplicateFactorProduct = factorGroups.fold!((a, b) => tuple(a[0] * b[0] ^^ (b[1] - 1), 1))(tuple(1uL, 1u))[0];
  auto duplicateFactorProduct = factorGroups.map!(a => a[0] ^^ (a[1] - 1)).fold!((a, b) => a * b);
  auto factors = factorGroups.map!(a => a[0]).array();
  T nonCoprimes = memoize!(getNonCoprimeCount!T)(factors);
  nonCoprimes *= duplicateFactorProduct;

  return number == 1 ? 1 : number - nonCoprimes;
}

T getTotientOld(T)(T number) if (isIntegral!T) {
  assert (number > 0);

  T[] factors = getDistinctPrimeFactors(number);

  T exclusiveMultiples(T factor, T[] moreFactors) {
    T multiples = (number - 1) / factor;
    T[] mask = new T[moreFactors.length];
    T mainFactor;
    T[] chosenFactors;
    T[] remainingFactors;

    void separate(out T[] chosenFactors, out T[] remainingFactors) {
      for (T i = 0; i < moreFactors.length; i++) {
        if (mask[i])
          chosenFactors ~= moreFactors[i];
        else
          remainingFactors ~= moreFactors[i];
      }
    }

    foreach (k; iota(0, mask.length).retro()) {
      mask[] = 0;
      mask[k .. $] = 1;
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

T[] getCoprimes(T)(T number) if (isIntegral!T) {
  T[] result;
  T[] factors = makePrimes
    .until!((a, b) => a >= b)(number)
    .setDifference(getDistinctPrimeFactors(number))
    .array();

  void inner(T product, T[] someFactors) {
    T nextProduct;

    result ~= product;

    foreach (i, f; someFactors) {
      nextProduct = product * f;

      if (nextProduct > number)
        break;

      inner(nextProduct, someFactors[i .. $]);
    }
  }

  assert (number > 0);

  inner(1, factors);

  return result;
}

auto getMultiTotientsInit(T)(T topNumber) if (isIntegral!T) {
  void getMultiTotients() {
    T[] factors = makePrimes
      .until!((a, b) => a >= b)(topNumber)
      .array();

    void inner(T baseNumber, T multiplier, T[] someFactors, T[] distinctFactors) {
      T totient = multiplier * (baseNumber - memoize!(getNonCoprimeCount!T)(distinctFactors[1 .. $]));

      yield(tuple(T(baseNumber * multiplier), T(totient)));

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

  assert (topNumber > 0);

  return &getMultiTotients;
}

auto getSortedDigitsInit(T)(T lowerUpper) if (isIntegral!T) {
  return getSortedDigitsInit(lowerUpper, lowerUpper);
}

auto getSortedDigitsInit(T)(T lower, T upper) if (isIntegral!T) {
  assert (lower > 0);
  assert (lower <= upper);
  int[] digits;

  void getSortedDigits() {
    void inner(size_t index, int start) {
      if (index == digits.length)
        return;

      foreach (d; start .. 10u) {
        inner(index + 1, d);
        digits[index .. $] = d;
        yield(digits.dup);
      }
    }

    foreach (T s; lower .. upper+1) {
      digits = new int[s];
      digits[] = 0;
      inner(0, 1);
    }
  }

  return &getSortedDigits;
}
