module kreikey.util;

import std.algorithm;

alias asort = (a) {a.sort(); return a;};
alias asortDescending = (a) {a.sort!((b, c) => c < b)(); return a;};

