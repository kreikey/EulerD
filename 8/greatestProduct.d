#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.file;
import std.datetime.stopwatch;
import productIter;

void main() {
  StopWatch sw;
  string digits;
  int product;
  ProductIter prodFive;

  sw.start();
  getData(digits);
  prodFive = new ProductIter(digits, 5);
  product = prodFive.getProduct();

  while (!prodFive.isFinished()) {
    if (prodFive.nextProduct() > product)
      product = prodFive.getProduct;
  }
  sw.stop();
  writeln(product);
  writeln("finished in ", sw.peek.total!"msecs"(), " milliseconds");
}

void getData(ref string text) {
  text = cast(string)read("digits.txt");
}
