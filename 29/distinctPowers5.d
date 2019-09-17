#!/usr/bin/env rdmd -i -I..

import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import std.experimental.allocator;
import std.experimental.allocator.mallocator;
import core.stdc.stdio;
import core.stdc.stdlib;

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

  // Imperative style. For the record.
  auto powersMatrix = alloc.makeMultidimensionalArray!(ulong[])(n - 1, n - 1);

  foreach(base; 2..n+1) {
    foreach(exponent; 2..n+1) {
      powersMatrix[base - 2][exponent - 2] = PrimeFactors(base)
        .cycleN(exponent)
        .rickarray
        .asort();
    }
    sort(powersMatrix[base - 2]);
  }
  auto flattened = powersMatrix.rickMultiMerge();

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

      //powersMatrix[base - 2][exponent - 2] = primeFactors(base)
        //.dupN(exponent)
        //.rickMultiMerge
        //.asort();

//ulong[] primeFactors(ulong num) {
  //size_t allocSize = 8;
  //ulong[] factors = alloc.makeArray!ulong(allocSize);
  //size_t ndx = 0;
  //ulong n = 2;

  //while (num > 1) {
    //while (num % n == 0) {
      //if (ndx == allocSize) {
        //alloc.expandArray(factors, allocSize);
        //allocSize *= 2;
      //}
      //factors[ndx++] = n;
      //num /= n;
    //}
    //n++;
  //}
  //alloc.shrinkArray(factors, (factors.length - ndx));

  //return factors;
//}

//ulong[] primeFactorsOld(ulong num) {
  //ulong[] factors;
  //ulong n = 2;

  //while (num > 1) {
    //while (num % n == 0) {
      //factors ~= n;
      //num /= n;
    //}
    //n++;
  //}

  //return factors;
//}

//T[][] dupN(T)(T[] arr, size_t copies) {
  //T[][] result = alloc.makeMultidimensionalArray!T(copies, arr.length);
  //foreach (ref row; result)
    //copy(arr, row);

  //return result;
//}

//size_t matLen(T)(T[][] matrix) {
  //size_t length = 0;

  //foreach(row; matrix) {
    //length += row.length;
  //}

  //return length;
//}

//void printmeta(T)(T[] arr) @nogc {
  //printf("ptr: %u, length: %d\n", arr.ptr, arr.length);
//}

//T[] rickMultiNoMerge(T)(T[][] matrix) {
  //scope(exit) alloc.dispose(matrix);
  //T[] result;
  //auto matLength = matLen(matrix);

  //if (matLength == 0) {
    //return result;
  //}

  //result = alloc.makeArray!T(matLength);

  //size_t i = 0;
  //foreach (ref row; matrix[0 .. $]) {
    //copy(row, result[i .. i + row.length]);
    //i += row.length;
    //alloc.dispose(row);
  //}

  //return result;
//}

