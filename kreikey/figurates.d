module kreikey.figurates;

import std.format;
import std.range;
import std.algorithm;
import std.functional;

enum Figurate {triangular = 1, square, pentagonal, hexagonal, heptagonal, octagonal}

bool delegate(ulong num) isTriangular;
bool delegate(ulong num) isSquare;
bool delegate(ulong num) isPentagonal;
bool delegate(ulong num) isHexagonal;
bool delegate(ulong num) isHeptagonal;
bool delegate(ulong num) isOctagonal;

static this() {
  isTriangular = isFigurateInit!(FigGen!(Figurate.triangular));
  isSquare = isFigurateInit!(FigGen!(Figurate.square));
  isPentagonal = isFigurateInit!(FigGen!(Figurate.pentagonal));
  isHexagonal = isFigurateInit!(FigGen!(Figurate.hexagonal));
  isHeptagonal = isFigurateInit!(FigGen!(Figurate.heptagonal));
  isOctagonal = isFigurateInit!(FigGen!(Figurate.octagonal));
}

string genFigurateLambda(int shape) {
  return q{(a,n) => (n+a[0])*(%1$s*(n+a[0])+2-%1$s)/2}.format(shape);
}

template FigGen(ulong shape, ulong offset = 0) {
  alias FigGen = sequence!(mixin(genFigurateLambda(shape)), ulong);
  alias FigGen = partial!(sequence!(mixin(genFigurateLambda(shape)), ulong), offset);
}

auto isFigurateInit(alias generator)() {
  auto temp = generator();
  bool[ulong] cache = null;

  return delegate(ulong num) {
    auto figurates = refRange(&temp);
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  };
}
