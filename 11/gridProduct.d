#!/usr/bin/env rdmd
import std.stdio;
import std.array;
import std.conv;
import std.algorithm;
import std.datetime.stopwatch;

void main() {
  StopWatch timer;
  int[] products;
  int maxProduct;

  timer.start();
  File inFile = File("gridNumbers.txt", "r");

  int[][] matrix = inFile.byLine.map!(line => line.idup.split(" ").map!(numstr => numstr.parse!(int)).array).array;
  //int[][] matrix = array(map!(line => array(map!(numstr => parse!(int)(numstr))(split(line.idup, " "))))(inFile.byLine));

  foreach (j; 0..matrix.length) {
    foreach (i; 0..matrix[0].length) {
      if (j < matrix.length - 3 && i < matrix[0].length - 3) {
        products ~= matrix[j+3][i] * matrix[j+2][i+1] * matrix[j+1][i+2] * matrix[j][i+3];  //NE diagonal product
        products ~= matrix[j][i] * matrix[j+1][i+1] * matrix[j+2][i+2] * matrix[j+3][i+3];  //SW diagonal product
      }
      if (j < matrix.length - 3)
        products ~= matrix[j][i] * matrix[j+1][i] * matrix[j+2][i] * matrix[j+3][i];  //vertical product
      if (i < matrix[0].length - 3)
        products ~= matrix[j][i] * matrix[j][i+1] * matrix[j][i+2] * matrix[j][i+3];  //horizontal product
    }
  }
  maxProduct = products.reduce!(max);
  writeln(maxProduct);
  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
