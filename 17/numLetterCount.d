#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime;
import std.conv;

void main(string args[]) {
  StopWatch sw;
  string result;
  int firstNum = 1;
  int lastNum = 1000;
  string delegate(int) numWrite;

  if (args.length > 2) {
    firstNum = args[1].to!int;
    lastNum = args[2].to!int;
  }

  if (!(lastNum >= firstNum && firstNum > 0)) {
    writeln("values out of order and/or out of range. using defaults");
    firstNum = 1;
    lastNum = 1000;
  }

  sw.start();
  numWrite = numToWordsInit();

  foreach (i; firstNum..lastNum + 1) {
    result ~= numWrite(i);
  }

  sw.stop();
  writefln("the numbers from %s to %s written out contain %s letters.", firstNum, lastNum, result.length);
  writefln("finished in %s milliseconds", sw.peek.msecs());
}

string delegate(int) numToWordsInit() {
  string[int] numWordMap = [1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven",
  8:"eight", 9:"nine", 10:"ten", 11:"eleven", 12:"twelve", 13:"thirteen", 14:"fourteen",
  15:"fifteen", 16:"sixteen", 17:"seventeen", 18:"eighteen", 19:"nineteen", 20:"twenty",
  30:"thirty", 40:"forty", 50:"fifty", 60:"sixty", 70:"seventy", 80:"eighty", 90:"ninety"];

  string numToWords(int num) {
    string numWord;

    if (num < 1) {
      numWord = "";
    } else if (num < 20) {
      numWord = numWordMap[num];
    } else if (num < 100) {
      numWord = numWordMap[num - (num % 10)] ~ numToWords(num % 10);
    } else if (num < 1000) {
      numWord = numToWords(num / 100) ~ "hundred" ~ (num % 100 > 0 ? "and" ~ numToWords(num % 100): "");
    } else if (num < 100000) {
      numWord = numToWords(num / 1000) ~ "thousand" ~ numToWords(num % 1000);
    }
    return numWord;
  }

  return &numToWords;
}

