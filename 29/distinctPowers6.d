#!/usr/bin/env rdmd -i -I..

import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import std.experimental.allocator;
import std.experimental.allocator.mallocator;
import core.stdc.stdio;
import core.stdc.stdlib;

template unpack(alias func)
{
  import std.typecons: isTuple;

  auto unpack(TupleType)(TupleType tup)
  if (isTuple!TupleType) {
    return func(tup.expand);
  }
}

alias alloc = Mallocator.instance;

void main(string[] args) @nogc {
  StopWatch timer;
  ulong n = 100;

  if (args.length > 1) {
    char[] nstr = nullTerminatedCopy(args[1]);
    scope(exit) alloc.dispose(nstr);
    n = atoi(nstr.ptr);
  }

  printf("distinct powers\n");

  timer.start();

  auto flattened = iota(2, n + 1)
    .zip(repeat(n))
    .map!(unpack!((base, end) => iota(2, end + 1)
      .zip(repeat(base))
      .map!(unpack!((base, exp) => PrimeFactors(base).cycleN(exp).rickarray.asort()))
      .rickarray
      .asort()))
    .rickarray
    .rickMultiMerge();

  scope(exit) alloc.disposeMultidimensionalArray(flattened);
  ulong number = flattened.uniq.count();
  printf("%d\n", number);

  timer.stop();
  printf("finished in %d milliseconds\n", timer.peek.total!"msecs"());
}

char[] nullTerminatedCopy(string str) @nogc {
  size_t resLen = str.length + 1;
  char[] result = alloc.makeArray!char(resLen);

  auto rem = copy(str, result);
  rem[0] = '\0';
  assert(rem.length == 1);

  return result;
}

T[] asort(T)(T[] array) {
  std.algorithm.sort(array);
  return array;
}

T[] rickMerge(T)(T[] left, T[] right) {
  scope(exit) {
    alloc.dispose(left);
    alloc.dispose(right);
  }

  T[] result = alloc.makeArray!T(left.length + right.length);
  size_t i = 0, j = 0, k = 0;

  while (k < result.length) {
    while (i < left.length && (j >= right.length || left[i] <= right[j])) {
      result[k++] = left[i++];
    }
    swap(i, j);
    swap(left, right);
  }
  return result;
}

T[] rickMultiMerge(T)(T[][] matrix) {
  scope(exit) alloc.dispose(matrix);
  T[] current;

  if (matrix.length == 0) {
    return current;
  }

  current = matrix[0];

  foreach (row; matrix[1..$]) {
    current = rickMerge(current, row);
  }

  return current;
}

auto cycleN(T, U)(T numbers, U copies)
if ((isInputRange!T && hasLength!T) || (isForwardRange!T && !isInfinite!T)) {
  return numbers.cycle.take(count(numbers) * copies);
}

auto rickarray(T)(T itemRange)
if ((isInputRange!T && hasLength!T) || (isForwardRange!T && !isInfinite!T)) {
  alias E = ElementType!T;
  E[] array = alloc.makeArray!(E)(count(itemRange));
  copy(itemRange, array);

  return array;
}

struct PrimeFactors {
  ulong num;
  ulong fac = 2;
  bool empty = false;

  this(ulong _num) @nogc {
    num = _num;
    popFront();
  }

  ulong front() @property @nogc {
    return fac;
  }

  void popFront() @nogc {
    if (num == 1 || num == 0) {
      empty = true;
    } else {
      while (num % fac != 0)
        fac++;
      num /= fac;
    }
  }

  typeof(this) save() @property @nogc {
    typeof(this) that = this;
    return that;
  }
}

