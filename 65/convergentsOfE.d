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

  auto digSum = convergents[99][0]
    .digitBytes
    .sum();

  auto r = new Eterms(&contFracE);

  writeln("The sum of the digits of the numerator of the 100th convergent of the continued fraction of e is:");
  writeln(digSum);
  timer.stop();
  writefln("Finished in %s milliseconds", timer.peek.total!"msecs"());
  // 6963524437876961749120273824619538346438023188214475670667
  //6 + 9 + 6 + 3 + 5 + 2 + 4 + 4 + 3 + 7 + 8 + 7 + 6 + 9 + 6 + 1 + 7 + 4 + 9 + 1 + 2 + 0 + 2 + 7 + 3 + 8 + 2 + 4 + 6 + 1 + 9 + 5 + 3 + 8 + 3 + 4 + 6 + 4 + 3 + 8 + 0 + 2 + 3 + 1 + 8 + 8 + 2 + 1 + 4 + 4 + 7 + 5 + 6 + 7 + 0 + 6 + 6 + 7
  //= 272
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

//struct ContinuedFraction(R, T = ElementType!R)
//if (isInputRange!(Unqual!R) && isIntegral!(ElementType!R) || is(ElementType!R == BigInt)) {
  //alias E = ElementType!R;
  //E first;
  //R range;
  //static if (hasLength!R)
    //alias Terms = typeof(only(first).chain(range.cycle()));
  //else
    //alias Terms = typeof(only(first).chain(range));
  //Terms terms;
  //size_t j = 0;
  //enum bool empty = false;
  //E[] cache;

  //this(R _terms) {
    //first = _terms.front;
    //range = _terms.dropOne();
    //static if (hasLength!R)
      //terms = only(first).chain(range.cycle());
    //else
      //terms = only(first).chain(range);
  //}

  //auto front() @property {
    //return this[j];
  //}

  //auto popFront() {
    //j++;
  //}

  //Tuple!(T, T) opIndex(size_t i) {
    //Tuple!(T, T) result = tuple(T(0), T(1));
    //E current;

    //Tuple!(T, T) inner(size_t j) {
      //Tuple!(T, T) local;

      //if (j == i) {
        //local[0] = T(1);
        //local[1] = T(cache[j]);
        //return local;
      //}

      //local = inner(j+1);
      //local[0] = T(cache[j]) * local[1] + local[0];
      //swap(local[0], local[1]);

      //return local;
    //}

    //while (i >= cache.length) {
      //cache ~= terms.front;
      //terms.popFront();
    //}

    //current = cache[0];

    //if (i > 0)
      //result = inner(1);

    //result[0] = T(current) * result[1] + result[0];

    //return result;
  //}
//}
