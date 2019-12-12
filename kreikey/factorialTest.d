#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.functional;
import kreikey.intmath;

//alias factorial = factorial2;

void main(string[] args) {
  ulong number = 0;
  ulong result;

  if (args.length > 1) {
    number = args[1].to!ulong();
  } else {
    writeln("Tell me what number to factorialize!");
    return;
  }

  result = factorial(number);
  writefln("factorial: %s", result);
}

//alias factorial = memoize!factorialImpl;
//ulong factorialImpl(ulong number) {
  //if (number == 1)
    //return number;
  //return number * memoize!factorialImpl(number - 1);
//}
