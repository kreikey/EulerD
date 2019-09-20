#!/usr/bin/env rdmd -i -I..

import std.stdio;
import kreikey.bigint;

ulong myHashOf(T)(auto ref T value) {
  return typeid(T).getHash(&value);
}

struct X {
  int a;
  double b;
}

void main() {
  BigInt a = 141746;
  BigInt b = 283;
  BigInt c;

  writeln(a.hashOf());
  c = a;
  writeln(c.hashOf());
  writeln(b.hashOf());
  writeln(a.hashOf());
  writeln();

  writeln(a.myHashOf());
  writeln(c.myHashOf());
  writeln(b.myHashOf());

  writeln();

  writeln(a.toHash());
  writeln(c.toHash());
  writeln(b.toHash());

  writeln();

  writeln(a.digitString.toHash());
  writeln(b.digitString.toHash());
  writeln(c.digitString.toHash());

  X z = X(3, 2.89);
  X y = X(9, 5.21);
  X x = z;

  writeln();

  writeln(z.myHashOf);
  writeln(y.myHashOf);
  writeln(x.myHashOf);
  writeln();

  //writeln(typeid(BigInt).getHash(&z));
  //writeln(typeid(BigInt).getHash(&y));
  //writeln(typeid(BigInt).getHash(&x));
}
