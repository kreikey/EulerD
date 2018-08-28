#!/usr/bin/env rdmd -I.. -i
 
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
		if (isTuple!TupleType)
	{
		return func(tup.expand);
	}
}

alias alloc = Mallocator.instance;

void main(string[] args) @nogc {
  StopWatch clock;
  ulong n = 100;

  if (args.length > 1) {
    char[] nstr = nullTerminatedCopy(args[1]);
    scope(exit) alloc.dispose(nstr);
    n = atoi(nstr.ptr);
  }

  printf("distinct powers\n");

  clock.start();

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

  clock.stop();
  printf("finished in %d milliseconds\n", clock.peek.total!"msecs"());
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
  size_t length = 0;
  static if (hasLength!T) {
    length = numbers.length;
  } else {
    length = count(numbers);
  }

  return numbers.cycle.take(length * copies);
}

auto rickarray(T)(T itemRange)
if ((isInputRange!T && hasLength!T) || (isForwardRange!T && !isInfinite!T)) {
  alias E = ElementType!T;
  size_t length = 0;
  static if (hasLength!T) {
    length = itemRange.length;
  } else {
    length = count(itemRange);
  }
  E[] array = alloc.makeArray!(E)(length);
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

//void printmeta(T)(T[] arr) @nogc {
  //printf("ptr: %u, length: %d\n", arr.ptr, arr.length);
//}

//T[][] dupN(T)(T[] arr, size_t copies) {
  //T[][] result = alloc.makeMultidimensionalArray!T(copies, arr.length);
  //foreach (ref row; result)
    //copy(arr, row);

  //return result;
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

//size_t matLen(T)(T[][] matrix) {
  //size_t length = 0;

  //foreach(row; matrix) {
    //length += row.length;
  //}

  //return length;
//}

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

//auto scaleAll(int[] xs, int m) @nogc {
    //import std.range: repeat, zip;
    //import std.algorithm: map;
    
    //return repeat(m).zip(xs).map!(unpack!((m, x) => m * x));
//}

