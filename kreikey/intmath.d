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

alias asort = (a) {a.sort(); return a;};
alias asortDescending = (a) {a.sort!((b, c) => c < b)(); return a;};
alias toString = digits => digits.map!(a => cast(immutable(char))(a + '0')).array();
alias InfiniteIota = recurrence!((a, n) => a[n-1]+1, ulong);

//ReturnType!(primeFactorsInit) PrimeFactors;
//static this() {
  //PrimeFactors primeFactors = primeFactorsInit();
//}

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
      a = a - b;
    else
      b = b - a;
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

T[] primeFactors2(T)(T num)
if (isIntegral!T) {
  T[] factors;
  T n = 2;

  if (num == 1)
    return [];

  while (num % n != 0)
    n++;

  if (num % n == 0)
    factors ~= n;

  return factors ~ memoize!(primeFactors2!T)(num / n);
}

T[] primeFactors1(T)(T num) 
if (isIntegral!T) {
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

T[] distinctPrimeFactors2(T)(T num)
if (isIntegral!T) {
  T[] factors;
  T n = 2;

  if (num == 1)
    return [];

  while (num % n != 0) {
    n++;
  }

  factors ~= n;

  while (num % n == 0) {
    num /= n;
  }

  return n ~ memoize!(distinctPrimeFactors2!T)(num);
}

T[] distinctPrimeFactors1(T)(T num)
if (isIntegral!T) {
  T[] factors;
  T n = 2;

  while (num > 1) {
    while (num % n != 0) {
      n++;
    }

    factors ~= n;

    while (num % n == 0) {
      num /= n;
    }
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

auto isPrimeInit(T = ulong)()
if (isIntegral!T) {
  Primes!T primes = new Primes!T();

  bool isPrime(T number) {
    auto primesCopy = primes.save;

    if (number <= primesCopy.topPrime)
      return number in primesCopy.cache ? true : false;

    auto root = std.math.sqrt(real(number)).to!T();
    auto found = primesCopy.find!(p => number % p == 0 || p > root)().front;

    return found > root;
  }

  return &isPrime;
}

uint[] toDigits(alias base = 10)(ulong source)
if (isIntegral!(typeof(base))) {
  ulong maxPowB = 1;
  uint[] result;

  while (maxPowB <= source)
    maxPowB *= base;

  if (source != 0)
    maxPowB /= base;

  while (maxPowB > 0) {
    result ~= cast(uint)source / maxPowB;
    source %= maxPowB;
    maxPowB /= base;
  }

  return result;
}

//uint[] toDigits(alias base = 10)(ulong source)
//if (isIntegral!(typeof(base))) {
  //if (source == 0)
    //return [];

  //return toDigits!base(source / base) ~ cast(uint)(source % base);
//}

ulong toNumber(alias base = 10)(uint[] digits) 
if (isIntegral!(typeof(base))) {
  ulong result;

  for (size_t i = 0; i < digits.length; i++) {
    result += digits[i] * base ^^ (digits.length - i - 1);
  }

  return result;
}

//ulong toNumber(alias base = 10)(uint[] digits) 
//if (isIntegral!(typeof(base))) {
  //if (digits.length == 0)
    //return 0;

  //return digits[0] * base ^^ (digits.length - 1) + toNumber!base(digits[1..$]);
//}

//alias factorial = memoize!factorialImpl;
//ulong factorialImpl(ulong number) {
  //if (number == 0 || number == 1)
    //return 1;
  //return number * memoize!factorialImpl(number - 1);
//}

ulong factorial(ulong number) {
  ulong result = 1;

  if (number == 0)
    return result;

  for (size_t n = 1; n < number + 1; n++)
    result *= n;

  return result;
}

T[] dror(T)(T[] digits) {
  T temp = digits[$-1];

  for (size_t i = digits.length-1; i > 0; i--)
    digits[i] = digits[i-1];

  digits[0] = temp;

  return digits;
}

ulong dror(T)(T source)
if(isIntegral!T) {
  return source.toDigits.dror.toNumber();
}

T[] drol(T)(T[] digits) {
  T temp = digits[0];

  for (size_t i = 0; i < digits.length-1; i++)
    digits[i] = digits[i+1];

  digits[$-1] = temp;

  return digits;
}

ulong drol(T)(T source)
if(isIntegral!T) {
  return source.toDigits.drol.toNumber();
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

