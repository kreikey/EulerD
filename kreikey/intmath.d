module kreikey.intmath;

import kreikey.bigint;
import std.algorithm;
import std.stdio;
import std.traits;
import kreikey.primes;
import std.range;

long[] getFactors(long number) {
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
  ulong t;

  while (b != a) {
    if (a > b)
      a = a - b;
    else
      b = b - a;
  }

  return b == 1;
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


T[] primeFactors(T)(T num) 
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

struct Factor {
  int factor;
  int multiplicity;
}

Factor maxMultiplicity(Factor a, Factor b) {
  return a.multiplicity > b.multiplicity ? a : b;
}

//bool isPrime(ulong number) {
  //ulong[] factors = primeFactors(number);
  //return factors.length == 1;
//}

//auto isPrimeInit() {
  //bool[ulong] primes;
  //ulong[] roots = [0, 1];
  //ulong topRoot = 1;
  //ulong topNum = 1;
  //primes[0] = false;
  //primes[1] = false;

  //bool isPrime(ulong number) {
    //ulong oldRoot = topRoot;
    //ulong oldNum = topNum;
    //bool* prime;

    //prime = number in primes;

    //if (prime != null)
      //return *prime;

    //while (number > topNum) {
      //topRoot += 1;
      //topNum = topRoot ^^ 2;

      //foreach (n; oldNum + 1 .. topNum)
        //roots ~= oldRoot;

      //roots ~= topRoot;

      //oldRoot = topRoot;
      //oldNum = topNum;
    //}

    //foreach (root; 2 .. roots[number] + 1) {
      //if (number % root == 0) {
        //primes[number] = false;
        //return false;
      //}
    //}

    //primes[number] = true;
    //return true;
  //}

  //return &isPrime;
//}

auto isPrimeInit(T)(Primes!T primes) if (isIntegral!T) {
  bool[T] primesCache;
  primesCache = primes.cache;

  bool isPrime(T number) {
    if (number > primes.topPrime)
      primes
        .find!((a, b) => a >= b)(number);

    return number in primesCache ? true : false;
  }

  return &isPrime;
}

ubyte[] toDigits(ulong source) {
  ulong maxPowTen = 1;
  ubyte[] result;

  while (maxPowTen <= source)
    maxPowTen *= 10;

  maxPowTen /= source != 0 ? 10 : 1;

  while (maxPowTen > 0) {
    result ~= cast(ubyte)(source / maxPowTen);
    source %= maxPowTen;
    maxPowTen /= 10;
  }

  return result;
}

ulong toNumber(ubyte[] digits) {
  ulong result = 0;

  foreach (i, n; digits)
    result += n * 10 ^^ (digits.length - 1 - i);

  return result;
}

ulong factorial(ulong number) {
  ulong result = 1;

  foreach (n; 1..number+1)
    result *= n;

  return result;
}

ubyte[] dror(ubyte[] digits) {
  ubyte temp;

  temp = digits[$-1];

  for (size_t i = digits.length-1; i > 0; i--)
    digits[i] = digits[i-1];

  digits[0] = temp;

  return digits;
}

ubyte[] drol(ubyte[] digits) {
  ubyte temp;

  temp = digits[0];

  for (size_t i = 0; i < digits.length-1; i++)
    digits[i] = digits[i+1];

  digits[$-1] = temp;

  return digits;
}

