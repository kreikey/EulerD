#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.concurrency;
import std.algorithm;
import std.range;
import kreikey.intmath;
import kreikey.bigint;

void main() {
  StopWatch timer;

  timer.start();
  writeln("Convergents of e");
  alias Eterms = Generator!ulong;
  auto convergents = ContinuedFraction!(Eterms, BigInt)(new Eterms(&contFracE));
  auto convergents2 = ContinuedFraction!(Eterms, BigInt)(new Eterms(&contFracE));

  writefln("%(%s/%s%)", convergents2[9]);
  //foreach (i; 0..10) {
    //writefln("%(%s/%s%)", convergents2[i]);
  //}
  
  //foreach (c; convergents.take(10)) {
    //writefln("%(%s/%s%)", c);
  //}

  //auto digSum = convergents[99][0]
    //.digitBytes
    //.sum();

  auto r = new Eterms(&contFracE);

  r.take(10).writeln();
  writeln("The sum of the digits of the numerator of the 100th convergent of the continued fraction of e is:");
  //writeln(digSum);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
}

void contFracE() {
  ulong k = 1uL;
  yield(2uL);

  for (int n = 2;; n++) {
    if (n == 3) {
      yield(2uL * k++);
      n = 0;
    } else {
      yield(1uL);
    }
  }
}

/*
 *struct ContinuedFraction(R, T = ElementType!R)
 *if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) || is(ElementType!R == BigInt)) {
 *  alias E = ElementType!R;
 *  E first;
 *  R range;
 *  size_t j = 0;
 *  enum bool empty = false;
 *
 *  this(R _terms) {
 *    first = _terms.front;
 *    range = _terms.dropOne();
 *  }
 *
 *  auto front() @property {
 *    return this[j];
 *  }
 *
 *  auto popFront() {
 *    j++;
 *  }
 *
 *  Tuple!(T, T) opIndex(size_t i) {
 *    Stack!(E) termStack;
 *    Tuple!(T, T) result;
 *    E current;
 *    result[1] = 1;
 *
 *    static if (hasLength!R)
 *      only(first).chain(range.cycle()).take(i+1).each!(a => termStack.push(a))();
 *    else
 *      only(first).chain(range).take(i+1).each!(a => termStack.push(a))();
 *
 *    current = termStack.pop();
 *    result[0] = T(current);
 *
 *    while (!termStack.empty) {
 *      swap(result[0], result[1]);
 *      current = termStack.pop();
 *      result[0] = T(current) * result[1] + result[0];
 *    }
 *
 *    return result;
 *  }
 *}
 */
