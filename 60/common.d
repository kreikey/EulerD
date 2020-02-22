module common;

import std.functional;
import std.traits;
import kreikey.intmath;
import kreikey.digits;

alias catsPrimeWith = memoize!catsPrimeWith1;
ReturnType!isPrimeInit isPrime;

static this() {
  isPrime = isPrimeInit();
}

bool catsPrimeWith1(ulong left, ulong right) {
  ulong cat1 = toNumber(left.toDigits ~ right.toDigits);

  if (!cat1.isPrime())
    return false;

  ulong cat2 = toNumber(right.toDigits() ~ left.toDigits);

  if (!cat2.isPrime())
    return false;

  return true;
}
