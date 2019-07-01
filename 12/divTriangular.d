#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;

void main(string[] args) {
  StopWatch sw;
  int trian;
  int topNum = 500;
  int n = 1;

  if (args.length > 1)
    topNum = args[1].parse!(int);

  sw.start();

  while (countTrianFactors(n) <= topNum) {
    n++;
  }

  writefln("n: %s t: %s factor count: %s", n, triangularize(n), countTrianFactors(n));
  sw.stop();
  writefln("finished in %s milliseconds.", sw.peek().total!"msecs");

}

int triangularize(int n) {
  return n * (n + 1) / 2;
}

int countTrianFactors(int n) {
  int count;

  if (n % 2 == 0)
    count = countFactors(n / 2) * countFactors(n + 1);
  else
    count = countFactors(n) * countFactors((n + 1)/2);

  return count;
}

int countFactors(int num) {
  static int[int] facCounts;
  int count;
  int max = num;
  int fac = 1;

  if (num in facCounts) {
    return facCounts[num];
  }

  while (fac < max) {
    if (num % fac == 0) {
      count += 2;
      max = num / fac;
      if (fac == max)
        count--;
    }
    fac++;
  }

  if (num == 1)
    count = 1;

  facCounts[num] = count;

  return count;
}

