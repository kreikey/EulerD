#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime;
import kreikey.bigint;
import core.stdc.stdlib;
import core.memory;
import std.algorithm;
import std.range;

void main() {
  //BigInt n = 3;
  //writeln(n);
  //auto q = n ^^ 29;
  //writeln(q);

  //assert(q.toString == "68630377364883");
  //BigInt m = 29;
  //q = n ^^ m;
  //assert(q.toString() == "68630377364883");
  BigInt a = 8192;
  BigInt b = 811;
  writeln(a * b);
  //writeln(++(a * b));

  //byte[] somedigs = [1, 2, 3, 4, 5];
  ////writeln(somedigs.toString());
  //writeln(somedigs);
  ////const(BigInt) num = 357834;
  ////writeln(num);
  //somedigs.hashOf.writeln();
  ////typeid(byte[]).getHash(&somedigs).writeln();
  //byte[] moredigs = [7, 3, 9, 6, 1, 3, 5, 8, 2];
  //moredigs.hashOf.writeln();

  //writeln("const test!!!");
  //const bool yesno = false;
  //bool thequestion = yesno;
  //writeln(thequestion);
  //writeln(typeof(thequestion).stringof);
  //thequestion = true;
  //writeln(thequestion);
  //const int x = 25;
  //int y = x;
  //y = 45;
  //writefln("x: %s; y: %s", x, y);
  //writefln("typeof x: %s; typeof y: %s", typeof(x).stringof, typeof(y).stringof);
  //int[] nums1 = [5, 7, 9, 2342, 3, 6, 11];
  //const(int[]) nums2 = [44, 6, 8, 31, 21, 90];
  //const(int[]) nums3 = nums2;
  //const(int[]) nums4;
  //nums4 = nums2;
  //nums1[3] = 1;
  //writeln(nums4);

  //writeln("divMod test!!!");
  //int c, d;
  //c = 17;
  //d = 3;
  //writeln(c / d);
  //writeln(c % d);
  //c = -c;
  //writeln(c / d);
  //writeln(c % d);
  //d = -d;
  //writeln(c / d);
  //writeln(c % d);
  //c = -c;
  //writeln(c / d);
  //writeln(c % d);
  //writeln((-0) / 5);
  //writeln((-0) % 5);
  //writeln((-15) % 16);
  // Conclusion: The remainder takes the sign of the dividend.

  //auto arr = iota(1, 10).array();
  //iota(1, 10).reduce!((a, b) => a + b).writeln();
  //int count = 0;
  //BigInt last = 0;
  //arr.each!((a) {
      ////writeln(a);
      ////writeln(b);
      //if (a != last)
        //count++;
      //last = a;
      //return count;
      //});
  //writeln(count);

  //writeln("length, ulong, and cast test");
  //string e = "goisdkljewrjlfs";
  //string f = "oidf";
  //auto g = e.length - f.length;
  //auto h = f.length - e.length;
  //writefln("g: %s type: %s", g, typeof(g).stringof);
  //writefln("h: %s type: %s", h, typeof(h).stringof);
  //writefln("cast(int)h: %s, type: %s", cast(int)h, typeof(cast(int)h).stringof);

  // Test abs and neg
  //BigInt z = 598;
  //writeln(z);
  //z = z.neg();
  //writeln(z);
  //z = z.abs();
  //writeln(z);

  // reserve test
  //int[] x = [1, 2, 3, 4, 5];
  //x.reserve(20);
  //writeln(x.capacity);
  //changeNumbers(x);
  //writeln(x.capacity);
  //int[] y;
  //writeln(y.capacity);
  //y = x;
  //writeln(y.capacity);
  // conclusion: You can reserve and pass to a function, and it will stick.

  // const array test
  //const byte[] x = [1, 2, 3, 4, 5];
  //byte[] y = [6, 7, 8, 9, 10];
  //writeln(x);
  //writeln(typeof(x).stringof);
  //writeln(y);
  //writeln(typeof(y).stringof);
  //useNumbers(y);
  //const(byte)[] z = [11, 12, 13, 14, 15];
  //writeln(z);
  //writeln(typeof(z).stringof);
  ////changeNumbers(z);
  //useNumbers(z);
  //playWithNumbers(z);

  // const array test
  const byte[] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  writeln(typeof(array).stringof);
  auto slice1 = array[0..3];
  writeln(slice1, typeof(slice1).stringof);
  auto slice2 = slice1.length < 3 ? slice1 : cast(byte[])[0];
  writeln(slice2, typeof(slice2).stringof);
  auto slice3 = cast(byte[])[0];
  writeln(slice3, typeof(slice3).stringof);
  //conclusion: casting a literal in a ternary operation will automatically apply const if the other type is const.



}

void changeNumbers(byte[] x) {
  writeln(x.capacity);
}

void useNumbers(const byte[] x) {
  writeln(x);
  writeln(typeof(x).stringof);
  writeln(x.capacity);
  //x.reserve(20);
  //writeln(x.capacity);
  //x ~= 5;
}

void playWithNumbers(const(byte)[] x) {
  writeln(x);
  writeln(typeof(x).stringof);
  writeln(x.capacity);
  x.reserve(20);
  writeln(x.capacity);
  x ~= 5;
  writeln(x);
  writeln(x.capacity);
  //x[2] = 0;
  //writeln(x);
  //x[5] = 0;
  //writeln(x);
  x.length = 20;
  writeln(x);
}

