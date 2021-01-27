module kreikey.figurates;

import std.format;
import std.range;
import std.algorithm;
import std.functional;

enum Figurates {triangular = 1, square, pentagonal, hexagonal, heptagonal, octagonal}

alias Triangulars = FigGen!(Figurates.triangular);
alias Squares = FigGen!(Figurates.square);
alias Pentagonals = FigGen!(Figurates.pentagonal);
alias Hexagonals = FigGen!(Figurates.hexagonal);
alias Heptagonals = FigGen!(Figurates.heptagonal);
alias Octagonals = FigGen!(Figurates.octagonal);
bool delegate(ulong num) isTriangular;
bool delegate(ulong num) isSquare;
bool delegate(ulong num) isPentagonal;
bool delegate(ulong num) isHexagonal;
bool delegate(ulong num) isHeptagonal;
bool delegate(ulong num) isOctagonal;

static this() {
  isTriangular = isFigurateInit!Triangulars();
  isSquare = isFigurateInit!Squares();
  isPentagonal = isFigurateInit!Pentagonals();
  isHexagonal = isFigurateInit!Hexagonals();
  isHeptagonal = isFigurateInit!Heptagonals();
  isOctagonal = isFigurateInit!Octagonals();
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
