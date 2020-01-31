module kreikey.util;

import std.algorithm;

//alias asort = (a) {a.sort(); return a;};
T[] asort(alias less = (a, b) => a < b, T)(T[] source) {
  source.sort!less();
  return source;
}

alias asortDescending = (a) {a.sort!((b, c) => c < b)(); return a;};

