#!/usr/bin/env rdmd -I..
import std.stdio;
import std.range;
import std.algorithm;

void main() {
  auto diags = generate(spiralDiagonalsInit());
  int n = 1001;
  diags.take((n - 1) * 2 + 1).sum.writeln();
}

auto spiralDiagonalsInit() {
  int i = 0;
  int n = 1;
  int stride = 2;

  int spiralDiagonals() {
    int lastn = n;
    if (i > 3) {
      stride += 2;
      i = 0;
    }
    i++;
    n += stride;
    return lastn;
  }

  return &spiralDiagonals;
}
