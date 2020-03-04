#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.range;
import std.algorithm;
import std.traits;
import std.meta;
import std.functional;
import kreikey.intmath;

template staticIota(size_t N) {
    import std.range: iota;
    import std.meta: aliasSeqOf;
    alias staticIota = aliasSeqOf!(N.iota);
}

template staticIota(size_t S, size_t E) {
    import std.range: iota;
    import std.meta: aliasSeqOf;
    alias staticIota = aliasSeqOf!(iota(S, E));
}

unittest {
    size_t count = 0;
    foreach (i; staticIota!10) {
        mixin("++count;");
    }
    assert(count == 10);
}

enum Figurate {Triangular, Square, Pentagonal, Hexagonal, Heptagonal, Octagonal}

bool delegate(ulong num)[] figurateCheckers;

//template genFigurateLambda(int mul) {
  //const char[] genFigurateLambda = "(a, n) => a[n-1] + " ~ mul.to!string() ~ " * n + 1";
//}

string genFiguratePredicate(int mul) {
  return "a[n-1] + " ~ mul.to!string() ~ " * n + 1";
}

static this() {
  foreach (n; staticIota!(1, 7))
    figurateCheckers ~= isFigurateInit!(recurrence!(genFiguratePredicate(n), ulong))();
}

void main() {
  StopWatch timer;

  timer.start();
  writefln("Cyclical figurate numbers");

  auto result = findSixCyclableFigurates();
  writefln("result: %s", result);
  writefln("sum: %s", result.sum());

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

bool mayCycle(ulong number) {
  return (number % 100) > 9;
}

auto allFiguratesRepresented(ulong[] numbers) {
  Figurate[] singularFiguratesFound;
  Figurate[] multiFiguratesFound;
  Figurate[] figuratesPerNumber;

  foreach (number; numbers) {
    foreach (isFigurate, FigurateType; lockstep(figurateCheckers, [EnumMembers!Figurate])) {
      if (isFigurate(number))
        figuratesPerNumber ~= FigurateType;
    }

    if (figuratesPerNumber.length > 1)
      multiFiguratesFound ~= figuratesPerNumber;
    else
      singularFiguratesFound ~= figuratesPerNumber;

    figuratesPerNumber = [];
  }

  auto totalFiguratesFound = multiFiguratesFound ~ singularFiguratesFound;

  if (totalFiguratesFound.sort.uniq.count() < 6)
    return false;

  return singularFiguratesFound.sort.group.all!(a => a[1] == 1)();
}

ulong[] findSixCyclableFigurates() {
  ulong[] result; 
  auto cyclable4DFigurates = getCyclable4DFigurates();
  auto cyclables = getCyclablesByDigits(cyclable4DFigurates);

  void inner(ulong[] cyclingFigurates, ulong depth) {
    if (depth == 6) {
      if (cyclingFigurates[$-1]%100 == cyclingFigurates[0]/100 && allFiguratesRepresented(cyclingFigurates))
        result = cyclingFigurates;
      return;
    }

    foreach (figurate; cyclables[cyclingFigurates[$-1] % 100]) {
      inner(cyclingFigurates ~ figurate, depth + 1);
      if (result.length != 0)
        break;
    }
  }

  foreach (figurate; cyclable4DFigurates) {
    inner([figurate], 1);
    if (result.length != 0)
      break;
  }

  return result;
}

ulong[] getCyclable4DFigurates() {
  ulong[][] fourDigitFiguratesGrid;

  //auto bleh = mixin(genFigurateLambda!(1));

  foreach (n; staticIota!(1, 7)) {
    fourDigitFiguratesGrid ~= recurrence!(genFiguratePredicate(n), ulong)(1).find!(a => a > 999).until!(a => a >= 10000).array();
  }

  return fourDigitFiguratesGrid.multiwayUnion.filter!mayCycle.array();
}

ulong[][ulong] getCyclablesByDigits(ulong[] fourDigitNumbers) {
  return fourDigitNumbers
    .chunkBy!((a, b) => a / 100 == b / 100)
    .map!(a => a.front / 100, a => a.array())
    .assocArray();
}

auto isFigurateInit(alias generator)() {
  auto temp = generator(1);
  bool[ulong] cache = null;

  bool isFigurate(ulong num) {
    auto figurates = refRange(&temp);
    if (figurates.front <= num)
      figurates.until!(a => a > num)
        .each!(a => cache[a] = true)();

    return num in cache ? true : false;
  }

  return &isFigurate;
}
