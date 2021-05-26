#!/usr/bin/env rdmd -i -I..

import std.stdio;

void main() {
  ulong x = 0;
  
  writeln("Coin partitions");

  for (uint n = 1;; n++) {
    x = countPartitionsVerySlow(n);
    writeln(n, " : ", x);
  }
}

ulong countPartitionsVerySlow(uint num) {
  ulong count = 0;

  void inner(uint[] numbers, uint total) {
    if (total >= num) {
      if (total == num) {
        count++;
      }
      return;
    }

    for (uint n = numbers[$-1]; n > 0; n--) {
      inner(numbers ~ n, total + n);
    }
  }

  inner([num], 0);

  return count;
}
