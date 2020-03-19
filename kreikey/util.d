module kreikey.util;

import std.algorithm;
import std.range;

alias InfiniteIota = recurrence!((a, n) => a[n-1]+1, ulong);

//alias asort = (a) {a.sort(); return a;};
T[] asort(alias less = (a, b) => a < b, T)(T[] source) {
  source.sort!less();
  return source;
}

alias asortDescending = (a) {a.sort!((b, c) => c < b)(); return a;};

template staticIota(size_t S, size_t E) {
    import std.range: iota;
    import std.meta: aliasSeqOf;
    alias staticIota = aliasSeqOf!(iota(S, E));
}

unittest {
    size_t count = 0;
    foreach (i; staticIota!(1, 11) {
        mixin("++count;");
    }
    assert(count == 10);
}

