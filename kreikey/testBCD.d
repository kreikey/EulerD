#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime;
import kreikey.bigint;
import core.stdc.stdlib;
import core.memory;

void main() {
  BigInt n = 3;
  auto q = n ^^ 29;
  writeln(q);

  assert(q.toString == "68630377364883");
  //BigInt a = 81;
  //BigInt b = 81;
  //writeln(a * b);
}

