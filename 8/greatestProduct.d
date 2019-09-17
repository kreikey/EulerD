#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.file;
import std.datetime.stopwatch;
import productIter;

void main() {
  StopWatch timer;
  string digits;
  int product;
  ProductIter prodFive;

  timer.start();
  getData(digits);
  prodFive = new ProductIter(digits, 5);
  product = prodFive.getProduct();

  while (!prodFive.isFinished()) {
    if (prodFive.nextProduct() > product)
      product = prodFive.getProduct;
  }
  timer.stop();
  writeln(product);
  writeln("finished in ", timer.peek.total!"msecs"(), " milliseconds");
}

void getData(ref string text) {
  text = cast(string)read("digits.txt");
}
