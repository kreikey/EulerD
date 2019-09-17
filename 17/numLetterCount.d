#!/usr/bin/env rdmd -I..
import std.stdio;
import std.datetime.stopwatch;
import std.conv;

void main(string[] args) {
  StopWatch timer;
  string result;
  int firstNum = 1;
  int lastNum = 1000;
  string delegate(int) numWrite;

  if (args.length > 2) {
    firstNum = args[1].parse!int();
    lastNum = args[2].parse!int();
  }

  if (!(lastNum >= firstNum && firstNum > 0)) {
    writeln("values out of order and/or out of range. using defaults");
    firstNum = 1;
    lastNum = 1000;
  }

  timer.start();
  numWrite = numToWordsInit();

  foreach (i; firstNum..lastNum + 1) {
    try {
      result ~= numWrite(i);
    } catch(Exception e) {
      writeln(e.msg);
      return;
    }
  }

  timer.stop();
  writefln("the numbers from %s parse %s written out contain %s letters.", firstNum, lastNum, result.length);
  writefln("finished in %s milliseconds", timer.peek.total!"msecs"());
}

string delegate(int) numToWordsInit() {
  string[int] numWordMap = [1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven",
  8:"eight", 9:"nine", 10:"ten", 11:"eleven", 12:"twelve", 13:"thirteen", 14:"fourteen",
  15:"fifteen", 16:"sixteen", 17:"seventeen", 18:"eighteen", 19:"nineteen", 20:"twenty",
  30:"thirty", 40:"forty", 50:"fifty", 60:"sixty", 70:"seventy", 80:"eighty", 90:"ninety"];

  string numToWords(int num) {
    string numWord;

    if (num >= 100000) {
      throw new Exception("num >= 100,000, which is not supported");
    }

    numWord = (num < 1) ? "" :
      (num < 20) ? numWordMap[num] :
      (num < 100) ? numWordMap[num - (num % 10)] ~ numToWords(num % 10) :
      (num < 1000) ? numToWords(num / 100) ~ "hundred" ~ (num % 100 > 0 ? "and" ~ numToWords(num % 100): "") :
      numToWords(num / 100) ~ "thousand" ~ numToWords(num % 1000);

    return numWord;
  }

  return &numToWords;
}

