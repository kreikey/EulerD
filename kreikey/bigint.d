module kreikey.bigint;

import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.stdio;
import std.math;
import std.range;
import std.traits;
import std.typecons;

mixin template RvalueRef() {
  alias T = typeof(this);
  static assert (is(T == struct));

  @nogc @safe
  ref const(T) byRef() const pure nothrow return 
  {
    return this;
  }
}

struct BigInt {
private:
	byte[] mant = [0];
	bool sign = false;
  static bool debugThis = false;

  //static byte[] addAbsInPlace(byte[] lhs, const(byte[]) rhs) {
    //uint i = 0;
    //uint carry = 0;

    //lhs.length = (lhs.length > rhs.length ? lhs.length : rhs.length) + 1;
    
    //while (i < rhs.length) {
      //lhs[i] += rhs[i] + carry;
      //if (lhs[i] > 9) {
        //lhs[i] -= 10;
        //carry = 1;
      //} else {
        //carry = 0;
      //}
      //i++;
    //}

    //while (carry) {
      //lhs[i] += carry;
      //if (lhs[i] == 10) {
        //lhs[i] = 0;
        //carry = 1;
      //} else {
        //carry = 0;
      //}
      //i++;
    //}

    //if (lhs[$-1] == 0)
      //lhs.length--;

    //return lhs;
  //}
  //unittest {
    //byte[] s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    //assert(s == [5, 0, 2, 5, 9]);
    //s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    //s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2, 7]);
    //assert(s == [5, 0, 2, 5, 6, 1]);
    //s = addAbsInPlace([4, 7, 3, 2], [1, 3, 8, 2, 9]);
    //assert(s == [5, 0, 2, 5, 9]);
    //s = addAbsInPlace([0], [0]);
    //assert(s == [0]);
    //s = addAbsInPlace([9], [1]);
    //assert(s == [0, 1]);
  //}

  static byte[] addAbsInPlace(byte[] lhs, const(byte[]) rhs) {
    uint carry = 0;

    lhs.length = lhs.length > rhs.length ? lhs.length : rhs.length;
    lhs[0 .. rhs.length] += rhs[];
    lhs[1 .. $] += lhs[0 .. $-1] / 10;
    carry = lhs[$-1] / 10;
    lhs[] %= 10;
    //lhs = carry ? lhs ~ 1 : lhs;
    if (carry)
      lhs ~= 1;

    return lhs;
  }
  unittest {
    writeln("addAbsInPlace unittest");
    byte[] s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    assert(s == [5, 0, 2, 5, 9]);
    s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    s = addAbsInPlace([1, 3, 8, 2, 9], [4, 7, 3, 2, 7]);
    assert(s == [5, 0, 2, 5, 6, 1]);
    s = addAbsInPlace([4, 7, 3, 2], [1, 3, 8, 2, 9]);
    assert(s == [5, 0, 2, 5, 9]);
    s = addAbsInPlace([0], [0]);
    assert(s == [0]);
    s = addAbsInPlace([9], [1]);
    assert(s == [0, 1]);
    writeln("addAbsInPlace unittest passed");
  }

  static byte[] addAbs(const(byte[]) lhs, const(byte[]) rhs) {
    return addAbsInPlace(lhs.dup, rhs);
  }
  unittest {
    writeln("addAbs unittest");
    byte[] a = [1, 1, 7, 6, 3, 4, 7, 4, 9];
    byte[] b = [9, 7, 8, 5, 4, 2, 3];
    byte[] c = [0];

    c = addAbs(a, b);
    assert(c == [0, 9, 5, 2, 8, 6, 0, 5, 9]);
    c = addAbs(b, a);
    assert(c == [0, 9, 5, 2, 8, 6, 0, 5, 9]);
    byte[] d = [9, 9, 9];
    byte[] e = [1];
    c = addAbs(d, e);
    assert(c == [0, 0, 0, 1]);
    c = addAbs(e, d);
    assert(c == [0, 0, 0, 1]);
    a = [1];
    b = [1];
    c = addAbs(a, b);
    assert(c == [2]);
    a = [0];
    b = [0];
    assert(a == [0]);
    assert(b == [0]);
    c = addAbs(a, b);
    assert(c == [0]);
    a = [0];
    b = [1];
    c = addAbs(a, b);
    assert(c == [1]);
    a = [9];
    b = [1];
    c = addAbs(a, b);
    assert(c == [0, 1]);
    writeln("addAbs unittest passed");
  }

  static byte[] addDigit(const(byte[]) lhs, uint dig) {
    return addDigitInPlace(lhs.dup, dig);
  }
  static byte[] addDigitInPlace(byte[] lhs, uint dig) {
    uint carry = 0;
    uint i = 0;

    if (BigInt.debugThis)
      writefln("lhs: %s dig: %s", lhs.toReverseString(), dig);

    lhs[i] += dig;
    if (lhs[i] > 9) {
      lhs[i] -= 10;
      carry = 1;
    } else {
      carry = 0;
    }
    i++;

    while (i < lhs.length) {
      lhs[i] += carry;
      if (lhs[i] > 9) {
        lhs[i] -= 10;
        carry = 1;
      } else {
        carry = 0;
      }
      i++;
    }
    if (carry)
      lhs ~= 1;

    if (BigInt.debugThis)
      writefln("result: %s", lhs.toReverseString());

    return lhs;
  }

  //static byte[] subAbsInPlace(byte[] lhs, const(byte[]) rhs) {
    //byte[] ninesComp = [];

    ////if (lhs.cmpAbs(rhs) < 0)
      ////throw new Exception("Subtrahend of absolute subtraction is greater than minuend");

    //ninesComp.length = lhs.length;
    //ninesComp[] = 9;
    //ninesComp[0 .. rhs.length] -= rhs[];
    //lhs = incAbs(addAbsInPlace(lhs, ninesComp));
    //do lhs.length--;
    //while(lhs[$ - 1] == 0 && lhs.length > 1);

    //return lhs;
  //}
  //unittest {
    //byte[] a = [0, 0, 1];
    //byte[] b = [1, 1];

    //a = subAbsInPlace(a, b);
    //assert(a == [9, 8]);
    //a = [1];
    //b = [1];
    //a = subAbsInPlace(a, b);
    //assert(a == [0]);
    //a = [0, 0, 1];
    //b = [9, 9];
    //a = subAbsInPlace(a, b);
    //assert(a == [1]);
  //}  

  static byte[] subAbsInPlace(byte[] lhs, const(byte[]) rhs) {
    //byte[] diff;
    ulong i = 0;
    uint borrow = 0;

    //if (cmpAbs(lhs, rhs) < 0)
      //throw new Exception("Subtrahend of absolute subtraction is greater than minuend");

    foreach (ref a, b; lockstep(lhs, rhs)) {
      a -= b + borrow;
      if (a < 0) {
        a += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
      i++;
    }

    while(borrow) {
      lhs[i] -= borrow;
      if (lhs[i] < 0) {
        lhs[i] += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
      i++;
    }

    while (lhs[$-1] == 0 && lhs.length > 1)
      lhs.length--;

    return lhs;
  }
  unittest {
    writeln("subAbsInPlace unittest");
    byte[] a = [0, 0, 1];
    byte[] b = [1, 1];

    a = subAbsInPlace(a, b);
    assert(a == [9, 8]);
    a = [1];
    b = [1];
    a = subAbsInPlace(a, b);
    assert(a == [0]);
    a = [0, 0, 1];
    b = [9, 9];
    a = subAbsInPlace(a, b);
    assert(a == [1]);
    writeln("subAbsInPlace unittest passed");
  }

  static byte[] subAbs(const(byte[]) lhs, const(byte[]) rhs) {
    byte[] difference = lhs.dup;
    difference = subAbsInPlace(difference, rhs);
    return difference;
  }
  unittest {
    writeln("subAbs unittest");
    byte[] c = [0];
    byte[] b = [9, 7, 8, 5, 4, 2, 3];
    byte[] a = [0, 9, 5, 2, 8, 6, 0, 5, 9];

    c = subAbs(a, b);
    assert(c == [1, 1, 7, 6, 3, 4, 7, 4, 9]);
    a = [0, 2];
    b = [0, 2];
    c = subAbs(a, b);
    assert(c == [0]);
    a = [0];
    b = [0];
    c = subAbs(a, b);
    assert(c == [0]);
    writeln("subAbs unittest passed");
  }

  static byte[] incAbs(byte[] lhs) {
    int carry = 1;

    foreach (ref d; lhs) {
      d += carry;
      if (d == 10) {
        d = 0;
      } else {
        carry = 0;
        break;
      }
    }

    if (carry) {
      lhs ~= 1;
    }
    return lhs;
  }
  unittest {
    writeln("incAbs unittest");
    byte[] a = [0];
    a = incAbs(a);
    assert(a == [1]);
    a = [9];
    a = incAbs(a);
    assert(a == [0, 1]);
    a = [9, 9, 9];
    a = incAbs(a);
    assert(a == [0, 0, 0, 1]);
    writeln("incAbs unittest passed");
  }

  static byte[] decAbs(byte[] lhs) {
    bool borrow = false;

    //if (lhs.cmpAbsOld(BigInt(1)) < 0)
        //throw new Exception("can't call decAbs() on a number whose absolute value is less than 1");

    ulong i = 0;

    do {
      if (lhs[i] > 0) {
        lhs[i]--;
        borrow = false;
      } else {
        lhs[i] = 9;
        borrow = true;
      }
      i++;
    } while (borrow);

    if (lhs[$ - 1] == 0 && lhs.length > 1)
      lhs.length--;

    return lhs;
  }
  unittest {
    writeln("decAbs unittest");
    byte[] a = [2];
    a = decAbs(a);
    assert(a == [1]);
    a = decAbs(a);
    assert(a == [0]);
    byte[] b = [0, 0, 0, 1];
    b = decAbs(b);
    assert(b == [9, 9, 9]);
    b = decAbs(b);
    assert(b == [8, 9, 9]);
    byte[] c = [1, 1];
    c = decAbs(c);
    assert(c == [0, 1]);
    c = decAbs(c);
    assert(c == [9]);
    byte[] d = [7];
    d = decAbs(d);
    assert(d == [6]);
    writeln("decAbs unittest passed");
  }

	int cmpAbsOld(const(BigInt) rhs) const {
		if (this.mant.length < rhs.mant.length)
			return -1;
		else if (this.mant.length > rhs.mant.length)
			return 1;

		foreach (i; retro(iota(0, this.mant.length)))
			if (this.mant[i] < rhs.mant[i])
				return -1;
			else if (this.mant[i] > rhs.mant[i])
				return 1;

		return 0;
	}
	unittest {
    writeln("cmpAbsOld unittest");
		BigInt a = BigInt(234);
		BigInt b = BigInt(969);
		BigInt c = BigInt(-1293);
		BigInt d = BigInt(45);
		BigInt e = BigInt(-969);
		BigInt f = BigInt(1199);

		assert(a.cmpAbsOld(b) < 0);
		assert(b.cmpAbsOld(a) > 0);
		assert(c.cmpAbsOld(d) > 0);
		assert(d.cmpAbsOld(c) < 0);
		assert(c.cmpAbsOld(d) > 0);
		assert(b.cmpAbsOld(e) == 0);
		assert(c.cmpAbsOld(f) > 0);
		assert(f.cmpAbsOld(c) < 0);
    writeln("cmpAbsOld unittest passed");
	}

  static int cmpAbs(const(byte[]) left, const(byte[]) right) {
    if (left.length < right.length)
      return -1;
    else if (left.length > right.length)
      return 1;

    foreach (a, b; lockstep(left.retro(), right.retro()))
      if (a < b)
        return -1;
      else if (a > b)
        return 1;

    return 0;
  }
	unittest {
    writeln("cmpAbs unittest");
		byte[] a = [2, 3, 4];
		byte[] b = [9, 6, 9];
		byte[] c = [1, 2, 9, 3];
		byte[] d = [4, 5];
		byte[] e = [9, 6, 9];
		byte[] f = [1, 1, 9, 9];

		assert(cmpAbs(a, b) < 0);
		assert(cmpAbs(b, a) > 0);
		assert(cmpAbs(c, d) > 0);
		assert(cmpAbs(d, c) < 0);
		assert(cmpAbs(c, d) > 0);
		assert(cmpAbs(b, e) == 0);
		assert(cmpAbs(c, f) < 0);
		assert(cmpAbs(f, c) > 0);
    writeln("cmpAbs unittest passed");
	}

	static byte[] karatsuba(const(byte)[] lhs, const(byte)[] rhs) {
		byte[] z0;
		byte[] z1;
		byte[] z2;
		byte n;
		ulong m;

    //writefln("lhs: %s; rhs: %s;", lhs, rhs);

    // Take care of base case where one or both operands are of length 1
    if (lhs.length == 1) {
      return mulSingleDigit(rhs, lhs[0]);
    } else if (rhs.length == 1) {
      return mulSingleDigit(lhs, rhs[0]);
    }

		m = lhs.length > rhs.length ? lhs.length / 2 : rhs.length / 2;
    //writefln("m: %s", m);

		// Split and handle out-of-bounds indices
		const(byte)[] highLeft = m >= lhs.length ? cast(byte[])[0] : lhs[m .. $];
		const(byte)[] lowLeft = m >= lhs.length ? lhs : lhs[0 .. m];
		const(byte)[] highRight = m >= rhs.length ? cast(byte[])[0] : rhs[m .. $];
		const(byte)[] lowRight = m >= rhs.length ? rhs : rhs[0 .. m];

		// Handle leading zeros
		while (lowLeft[$ - 1] == 0 && lowLeft.length > 1)
			lowLeft.length--;
		while(lowRight[$ - 1] == 0 && lowRight.length > 1)
			lowRight.length--;

    //writefln("lowleft: %s highleft %s", lowLeft, highLeft);
    //writefln("lowRight: %s highRight %s", lowRight, highRight);

		z2 = karatsuba(highLeft, highRight);
		z0 = karatsuba(lowLeft, lowRight);
		z1 = karatsuba(addAbs(lowLeft, highLeft), addAbs(lowRight, highRight));

    //writefln("z0: %s, z1: %s, z2: %s", z0, z1, z2);

		//return z2.shiftBig(2 * m)
				//.addAbs(z1
					//.subAbs(z2)
					//.subAbs(z0)
					//.shiftBig(m))
				//.addAbs(z0);

		return addAbsInPlace(
      addAbsInPlace(
        shiftBig(z2, 2 * m), 
        shiftBig(
          subAbsInPlace(
            subAbsInPlace(z1, z2),
            z0),
          m)),
      z0);
	}

  static byte[] shiftBigInPlace(byte[] lhs, ulong n) {
    if (lhs[$ - 1] == 0)
      return lhs;

    lhs.length += n;

    for (ulong i = lhs.length; i > n; i--) {
      lhs[i - 1] = lhs[i - n - 1];
    }

    lhs[0 .. n] = 0;

    return lhs;
  }
  unittest {
    writeln("shiftBigInPlace unittest");
    byte[] a = "1234".toReverseBytes();
    byte[] b = "4000".toReverseBytes();

    a = shiftBigInPlace(a, 5);
    assert(a.toReverseString() == "123400000");
    b = shiftBigInPlace(b, 2);
    assert(b.toReverseString() == "400000");
    a = shiftBigInPlace(a, 1);
    assert(a.toReverseString() == "1234000000");
    a = "20".toReverseBytes();
    a = shiftBigInPlace(a, 2);
    assert(a.toReverseString() == "2000");
    writeln("shiftBigInPlace unittest passed");
  }

	// Multiplies by a power of 10
	static byte[] shiftBig(byte[] lhs, ulong n) {
    return shiftBigInPlace(lhs.dup, n);
	}
  unittest {
    writeln("shiftBig unittest");
    auto a = BigInt(1234);
    auto b = BigInt(4000);
    BigInt c;

    c = BigInt(shiftBig(a.mant, 5), a.sign);
    assert(c.toString() == "123400000");
    c = BigInt(shiftBig(b.mant, 2), b.sign);
    assert(c.toString() == "400000");
    c = BigInt(shiftBig(a.mant, 1), a.sign);
    assert(c.toString() == "12340");
    a = BigInt(20);
    c = BigInt(shiftBig(a.mant, 2), a.sign);
    assert(c.toString() == "2000");
    writeln("shiftBig unittest passed");
  }

  static byte[] shiftLittleInPlace(byte[] lhs, ulong n) {
    if (lhs[$ - 1] == 0)
      return lhs;

    if (n >= lhs.length) {
      lhs.length = 1;
      lhs[0] = 0;
      return lhs;
    }

    for (ulong i = 0; i < lhs.length - n; i++) {
      lhs[i] = lhs[i + n];
    }

    lhs.length = lhs.length - n;

    return lhs;
  }

	static byte[] shiftLittle(byte[] lhs, ulong n) {
    return shiftLittleInPlace(lhs.dup, n);
  }
  unittest {
    writeln("shiftLittleInPlace unittest");
    auto a = BigInt(123400000);
    auto b = BigInt(400000);
    BigInt c;

    c = BigInt(shiftLittle(b.mant, 2), b.sign);
    assert(c.toString() == "4000");
    c = BigInt(shiftLittle(a.mant, 1), a.sign);
    assert(c.toString() == "12340000");
    c = BigInt(shiftLittle(a.mant, 2), a.sign);
    assert(c.toString() == "1234000");
    c = BigInt(shiftLittle(a.mant, 3), a.sign);
    assert(c.toString() == "123400");
    c = BigInt(shiftLittle(a.mant, 4), a.sign);
    assert(c.toString() == "12340");
    c = BigInt(shiftLittle(a.mant, 5), a.sign);
    assert(c.toString() == "1234");
    c = BigInt(shiftLittle(a.mant, 6), a.sign);
    assert(c.toString() == "123");
    c = BigInt(shiftLittle(a.mant, 7), a.sign);
    assert(c.toString() == "12");
    c = BigInt(shiftLittle(a.mant, 8), a.sign);
    assert(c.toString() == "1");
    c = BigInt(shiftLittle(a.mant, 9), a.sign);
    assert(c.toString() == "0");
    writeln("shiftLittleInPlace unittest passed");
  }

	static byte[] mulSingleDigit(const(byte[]) lhs, const(byte) n) {
		byte[] pro = lhs.dup;
		byte carry;

		pro[] *= n;

		foreach (ref a; pro) {
			a += carry;
			carry = a / 10;
		}

		if (carry)
			pro ~= carry;

		pro[] %= 10;

		// In case we've multiplied by a zero, set length to one.
		if (pro[$ - 1] == 0)
			pro.length = 1;

		return pro;
	}
	unittest {
    writeln("mulSingleDigit unittest");
		auto a = BigInt(23432);
		auto b = BigInt(87263);
		auto c = BigInt(-32786); 
		auto d = BigInt(0);
		BigInt r;
		byte w = 0;
		byte x = 4;
		byte y = 9;
		byte z = 3;

		assert(BigInt(mulSingleDigit(a.mant, x), a.sign).toString() == "93728");
		assert(BigInt(mulSingleDigit(a.mant, y), a.sign).toString() == "210888");
		assert(BigInt(mulSingleDigit(a.mant, z), a.sign).toString() == "70296");
		assert(BigInt(mulSingleDigit(b.mant, x), a.sign).toString() == "349052");
		assert(BigInt(mulSingleDigit(b.mant, y), a.sign).toString() == "785367");
		assert(BigInt(mulSingleDigit(b.mant, z), a.sign).toString() == "261789");
		assert(BigInt(mulSingleDigit(c.mant, x), a.sign).toString() == "131144");
		assert(BigInt(mulSingleDigit(c.mant, y), a.sign).toString() == "295074");
		assert(BigInt(mulSingleDigit(c.mant, z), a.sign).toString() == "98358");
		assert(BigInt(mulSingleDigit(d.mant, w), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(d.mant, x), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(d.mant, y), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(d.mant, z), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(a.mant, w), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(b.mant, w), a.sign).toString() == "0");
		assert(BigInt(mulSingleDigit(c.mant, w), a.sign).toString() == "0");
    writeln("mulSingleDigit unittest passed");
	}

  Tuple!(byte[], byte[]) divMod(const(byte)[] lhs, const(byte)[] rhs) const {
    // This function could use some serious reworking and updating, for optimization purposes.
    byte[] quo;
    byte[] rem;
		byte[] acc;
		byte dig;
		int littleEnd, bigEnd;
    
		if (rhs == [0])
			throw new Exception("Divide by zero error.");
		if (cmpAbs(lhs, rhs) < 0) {
			return Tuple!(byte[], byte[])([0], lhs.dup);
		}

		// Needs to examine the lengths of each number and act accordingly.
		// We want this to work regardless of which side has the bigger number.
		// Modulus by a bigger number should yield the number itself.
		
		littleEnd = cast(int)(lhs.length - rhs.length);
		littleEnd = littleEnd > 0 ? littleEnd : 0;
		bigEnd = cast(int)(lhs.length);

		if (cmpAbs(rhs, lhs[littleEnd .. bigEnd]) > 0 && littleEnd > 0) {
			littleEnd--;
		}

		byte[] divid = lhs[littleEnd .. bigEnd].dup;

    // We're building up the quotient digit-by-digit, so the length of the mantissa must be 0
    quo.length = 0;

		do {
			dig = 0;
			acc = rhs.dup;  // I'm not sure if I need to dup here

			while (cmpAbs(acc, divid) <= 0) {
				dig++;
				acc = addAbs(acc, rhs);
			}

			quo ~= dig;
			rem = subAbs(divid, subAbs(acc, rhs));

			if (littleEnd > 0) { 
				divid = addDigit(shiftBig(rem, 1), lhs[littleEnd - 1]);
			}

		} while (littleEnd-- > 0);

		std.algorithm.reverse(quo);

    // It's probably better to return a (BigInt, BigInt) pair rather than a pair of byte[]s because I need to calculate signs somewhere.
    // If I calculate divMod in one place, I might as well calculate the signs in the same place.
    // Now, I could theoretically calculate them in div() and mod() respectively, but then I would need to look at the signs of the operands.
    // Actually, that might be just as good. Then when I implement caching of the last divMod operation, I could take that into account.
    // I could look only at the byte[]s of each cached operand, then consider the signs of the actual operand.
    // Or I would just look at the BigInt operands.

    BigInt.debugThis = false;

    return Tuple!(byte[], byte[])(quo, rem);
  }

  BigInt powFast(T)(auto ref const(T) exp) const
  if (isIntegral!T || is(T == BigInt)) {
    const(byte)[] powInternal(T)(auto ref const(T) exp) 
    if (isIntegral!T || is(T == BigInt)) {
      T rem = 0;
      T halfExp;

      if (exp < 0) {
        throw new Exception("It's an integer library, not a fraction or floating point library. No negative exponents allowed!");
      } else if (exp == 0) {
        return [1];
      } else if (exp == 1) {
        return this.mant;
      }

      halfExp = exp / 2;
      static if (is(T == BigInt))
        rem = BigInt.lastRemainder;
      else
        rem = exp % 2;

      static if (is(T == BigInt)) {
        const(byte)[] left = powInternal(halfExp.byRef());
        const(byte)[] right = powInternal(BigInt(addAbsInPlace(halfExp.mant, rem.mant), false).byRef());
      } else {
        const(byte)[] left = powInternal(halfExp);
        const(byte)[] right = powInternal(halfExp + rem);
      }

      return karatsuba(left, right);
    }

    static if (is(T == BigInt)) {
      // How do I make this more efficient? Copying a BigInt with the * operator is not acceptable. Karatsuba() should be used instead.
      //BigInt result;
      //result = BigInt(result.mant, (this.sign && exp % 2));
      bool odd = exp % 2 == 1 ? true : false;
      bool sign = this.sign && odd;
      //result.sign = this.sign && odd;
      //result.mant = powInternal(exp);
      BigInt result = BigInt(powInternal(exp), sign);
      return result;
    } else {
      return BigInt(powInternal(exp), this.sign && exp % 2);
    }
  }
  unittest {
    writeln("powFast unittest");
    BigInt a = 2;
    assert(a.toString() == "2");
    BigInt b = 5;
    assert(b.toString() == "5");
    BigInt c = 3;
    BigInt z = a.powFast(13);
    //writefln("pow result: %s", z);
    assert(z.toString() == "8192");
    z = b.powFast(13);
    assert(z.toString() == "1220703125");
    BigInt y = c.powFast(29);
    assert(y.toString() == "68630377364883");
    BigInt e = 13;
    assert(e.powFast(11).toString() == "1792160394037");
    assert(e.powFast(14).toString() == "3937376385699289");
    BigInt d = 13;
    z = a.powFast(d);
    assert(z.toString() == "8192");
    writeln("powFast unittest passed");
  }

  BigInt add()(auto ref const(BigInt) rhs) const {
		BigInt sum;

    int cmpRes = cmpAbs(this.mant, rhs.mant);
    const(byte[]) big = cmpRes < 0 ? rhs.mant : this.mant;
    const(byte[]) little = cmpRes >= 0 ? rhs.mant : this.mant;

		if (this.sign == rhs.sign) {
			sum.mant = addAbs(big, little);
			sum.sign = this.sign;
		} else {
      sum.mant = subAbs(big, little);
      sum.sign = cmpRes > 0 ? this.sign : rhs.sign;
    }

		if (sum.mant[$ - 1] == 0)
			sum.sign = false;

		return sum;
	}
	unittest {
    writeln("add unittest");
		BigInt a = BigInt(2948);
		BigInt b = BigInt(38);
		BigInt c = BigInt(-10392);
		BigInt d = BigInt(-438);
		BigInt f = BigInt(10392);
		BigInt g = BigInt(-10300);
		BigInt h = BigInt(873);
		BigInt i = BigInt(218);
		BigInt e;

		e = a.add(b);
		assert(e.toString() == "2986");
		e = b.add(a);
		assert(e.toString() == "2986");
		e = a.add(d);
		assert(e.toString() == "2510");
		e = d.add(a);
		assert(e.toString() == "2510");
		e = a.add(c);
		assert(e.toString() == "-7444");
		e = c.add(a);
		assert(e.toString() == "-7444");
		e = c.add(d);
		assert(e.toString() == "-10830");
		e = d.add(c);
		assert(e.toString() == "-10830");
		e = f.add(g);
		assert(e.toString() == "92");
		e = g.add(f);
		assert(e.toString() == "92");
		e = h.add(i);
		assert(e.toString() == "1091");
		e = i.add(h);
		assert(e.toString() == "1091");		
    writeln("add unittest passed");
	}

	BigInt sub()(auto ref BigInt rhs) {
		BigInt diff = BigInt();

    int cmpRes = cmpAbs(this.mant, rhs.mant);
    byte[] big = cmpRes < 0 ? rhs.mant : this.mant;
    byte[] little = cmpRes >= 0 ? rhs.mant : this.mant;

		if (this.sign == rhs.sign) {
      diff.mant = subAbs(big, little);
      diff.sign = cmpRes > 0 ? this.sign : !this.sign;
		} else {
			diff.mant = addAbs(big, little);
			diff.sign = this.sign;
		}
	
		if (diff.mant[$ - 1] == 0)
			diff.sign = false;

		return diff;
	}
	unittest {
    writeln("sub unittest");
		BigInt a = BigInt(2948);
		BigInt b = BigInt(38);
		BigInt c = BigInt(-10392);
		BigInt d = BigInt(-438);
		BigInt f = BigInt(10392);
		BigInt g = BigInt(-10300);
		BigInt h = BigInt(873);
		BigInt i = BigInt(218);
		BigInt e;

		e = a.sub(b);
		assert(e.toString() == "2910");
		e = b.sub(a);
		assert(e.toString() == "-2910");
		e = a.sub(d);
		assert(e.toString() == "3386");
		e = d.sub(a);
		assert(e.toString() == "-3386");
		e = a.sub(c);
		assert(e.toString() == "13340");
		e = c.sub(a);
		assert(e.toString() == "-13340");
		e = c.sub(d);
		assert(e.toString() == "-9954");
		e = d.sub(c);
		assert(e.toString() == "9954");
		e = f.sub(g);
		assert(e.toString() == "20692");
		e = g.sub(f);
		assert(e.toString() == "-20692");	
		e = h.sub(i);
		assert(e.toString() == "655");
		e = i.sub(h);
		assert(e.toString() == "-655");	
    writeln("sub unittest passed");
	}

  ref BigInt inc() {
    if (this.sign) {
      this.mant = decAbs(this.mant);
    } else {
      this.mant = incAbs(this.mant);
    }

    if (this.mant[$ - 1] == 0)
      this.sign = false;

    return this;
  }
  unittest {
    writeln("inc unittest");
    BigInt a = BigInt(555);
    a.inc();
    assert(a.toString() == "556");
    BigInt b = BigInt(999);
    b.inc();
    assert(b.toString() == "1000");
    BigInt c = BigInt(-10);
    c.inc();
    assert(c.toString() == "-9");
    BigInt d = BigInt(-1);
    d.inc();
    assert(d.toString() == "0");
    d.inc();
    assert(d.toString() == "1");
    d.inc();
    assert(d.toString() == "2");
    BigInt e = BigInt(-1000);
    e.inc();
    assert(e.toString() == "-999");
    BigInt f = BigInt(9);
    f.inc();
    assert(f.toString() == "10");
    writeln("inc unittest passed");
  }

  ref BigInt dec() {
    if (this.sign) {
      this.mant = incAbs(this.mant);
    } else if (this.mant[$ - 1] == 0) {
      this.mant = incAbs(this.mant);
      this.sign = true;
    } else {
      this.mant = decAbs(this.mant);
    }

    if (this.mant[$ - 1] == 0)
      this.sign = false;

    return this;
  }
  unittest {
    writeln("dec unittest");
    BigInt a = BigInt(2);
    a.dec();
    assert(a.toString() == "1");
    a.dec();
    assert(a.toString() == "0");
    a.dec();
    assert(a.toString() == "-1");
    a.dec();
    assert(a.toString() == "-2");
    BigInt b = BigInt(-9);
    b.dec();
    assert(b.toString() == "-10");
    BigInt c = BigInt(10);
    c.dec();
    assert(c.toString() == "9");
    BigInt d = BigInt(1000);
    d.dec();
    assert(d.toString() == "999");
    BigInt e = BigInt(-999);
    e.dec();
    assert(e.toString() == "-1000");
    writeln("dec unittest passed");
  }

	BigInt mul()(auto ref const(BigInt) rhs) const {
    //writefln("multiply. lhs: %s rhs: %s", this, rhs);
    //writefln("lhs is rhs? %s", this is rhs);
		BigInt pro;
    pro.mant = karatsuba(this.mant, rhs.mant);

		if (pro.mant[$ - 1] == 0)
			pro.sign = false;
		else
			pro.sign = this.sign != rhs.sign;

		return pro;
	}
	unittest {
    writeln("mul unittest");
		auto a = BigInt(999);
		auto b = BigInt(9);

		auto c = a.mul(b);
		assert(c.toString() == "8991");
		a = BigInt(20);
		b = BigInt(100);
		c = a.mul(b);
    //writefln("mul: %s * %s = %s", a, b, c);
		assert(c.toString() == "2000");
		a = BigInt(23);
		b = BigInt(468725);
		c = b.mul(a);
		assert(c.toString() == "10780675");
		c = a.mul(b);
		assert(c.toString() == "10780675");
		a = BigInt(0);
		b = BigInt(8625);
		c = a.mul(b);
		assert(c.toString() == "0");
		c = b.mul(a);
		assert(c.toString() == "0");
		b = BigInt(-4821);
		c = a.mul(b);
		assert(c.toString() == "0");
		c = b.mul(a);
		assert(c.toString() == "0");
		a = BigInt(-348);
		b = BigInt(18093);
		c = a.mul(b);
		assert(c.toString() == "-6296364");
		b = BigInt(-18093);
		c = a.mul(b);
		assert(c.toString() == "6296364");
		a = BigInt("23948721364098026124547136489713276176241902300431270126932");
		b = BigInt("5727419348513774613649123241532987615320912874621306347055");
		c = a.mul(b);
		assert(c.toString() == "137164370112900232460570694377817339444040259594486075211695904902934240842284227954842058979389246516226067094385260");
		a = BigInt("30000000000000000");
		b = BigInt("40000000000000001");
		c = a.mul(b);
		assert(c.toString() == "1200000000000000030000000000000000");
    a = BigInt(5);
    b = BigInt(7);
    c = a.mul(b);
    assert(c.toString() == "35");
    c = b.mul(a);
    assert(c.toString() == "35");
    a = BigInt(64);
    b = BigInt(128);
    c = a.mul(b);
    assert(c.toString() == "8192");
    writeln("mul unittest passed");
	}

  BigInt neg() {
    BigInt copy = this;
    copy.sign = !copy.sign;
    return copy;
  }

	BigInt div()(auto ref const(BigInt) rhs) const {
    BigInt quo;

    auto result = divMod(this.mant, rhs.mant);

    quo = BigInt(result[0], result[0][$-1] == 0 ? false : (this.sign != rhs.sign));
    BigInt.lastQuotient = BigInt(quo.mant.dup, quo.sign);
    BigInt.lastRemainder = BigInt(result[1].dup, result[1][$-1] == 0 ? false : this.sign);

		return quo;
	}
	unittest {
    writeln("div unittest");
		auto a = BigInt(476);
		auto b = BigInt(12);
		auto d = BigInt(23803671638400872);
		auto e = BigInt(4871830);
		auto f = BigInt(100);
		auto g = BigInt(-8271);
		auto h = BigInt(0);
    auto i = BigInt(-15);
    auto j = BigInt(16);
    auto k = BigInt(5);

		auto z = a.div(b);
		assert(z.toString() == "39");
		z = d.div(e);
		assert(z.toString() == "4885981579");
		z = a.div(f);
		assert(z.toString() == "4");
		z = g.div(b);
		assert(z.toString() == "-689");
		z = g.div(e);
		assert(z.toString() == "0");
		z = d.div(g);
		assert(z.toString() == "-2877967795720");
		z = f.div(a);
		assert(z.toString() == "0");
    z = i.div(j);
    assert(z.toString() == "0");
    z = i.div(k);
    assert(BigInt.lastRemainder.toString() == "0");
    writeln("div unittest passed");
	}

	BigInt mod()(auto ref const(BigInt) rhs) const {
    BigInt rem;

    auto result = divMod(this.mant, rhs.mant);
    rem = BigInt(result[1], result[1][$-1] == 0 ? false : this.sign);
    BigInt.lastQuotient = BigInt(result[0].dup, result[0][$-1] == 0 ? false : (this.sign != rhs.sign));
    BigInt.lastRemainder = BigInt(rem.mant.dup, rem.sign);

		return rem;
	}
	unittest {
    writeln("mod unittest");
		auto a = BigInt(476);
		auto b = BigInt(12);
		auto c = BigInt(23803671638400872);
		auto d = BigInt(4871830);
		auto e = BigInt(-23803671638400872);
		auto f = BigInt(-4871830);
		auto g = BigInt(120);
		auto h = BigInt(-8271);
		auto i = BigInt(0);
    auto j = BigInt(-15);
    auto k = BigInt(-5);
    auto l = BigInt(16);

		auto z = a.mod(b);
		assert(z.toString() == "8");
		z = c.mod(d);
		assert(z.toString() == "2381302");
		z = c.mod(f);
		assert(z.toString() == "2381302");
		z = e.mod(d);
		assert(z.toString() == "-2381302");
		z = e.mod(f);
		assert(z.toString() == "-2381302");		
		z = g.mod(b);
		assert(z.toString() == "0");
    z = j.mod(k);
    assert(z.toString() == "0");
    z = j.mod(l);
    assert(z.toString() == "-15");
    assert(BigInt.lastQuotient.toString() == "0");
    z = h.mod(j);
    assert(z.toString() == "-6");
    z = h.mod(g);
    assert(z.toString() == "-111");
    z = f.mod(j);
    assert(z.toString() == "-10");
    z = f.mod(g);
    assert(z.toString() == "-70");
    z = b.mod(k);
    assert(z.toString() == "2");
    z = l.mod(k);
    assert(z.toString() == "1");
    writeln("div unittest passed");
	}

public:
  static BigInt lastQuotient;
  static BigInt lastRemainder;

	this(string source) nothrow {
		bool allZeros = true;
    bool valid = true;

		if (source[0] == '-') {
			this.sign = true;
			source = source[1 .. $];
		}

		foreach (c; source) {
			if (c < '0' || c > '9')
				valid = false;
			if (c != '0')
				allZeros = false;
		}

    assert(valid == true);

		this.mant.length = source.length;
		this.mant[] = cast(byte[])(source);
		this.mant[] -= '0';
		std.algorithm.reverse(this.mant);

		if (this.mant.length >= 1 && allZeros)
			this.mant.length = 1;
	}
	unittest {
    writeln("this(string) unittest");
		BigInt num = BigInt("100");
		assert(num.mant == [0, 0, 1]);
		assert(num.sign == false);

		BigInt num2 = BigInt("-321");
		assert(num2.mant == [1, 2, 3]);
		assert(num2.sign == true);
    writeln("this(string) unittest passed");
	}

	this(long source) nothrow {
		byte digit;

		this.mant.length = 1;
		this.mant[0] = 0;
		this.sign = false;

		if (source != 0)
			this.mant.length = 0;

		if (source < 0)
			this.sign = true;

		source = abs(source);

		while (source > 0) {
			digit = source % 10;
			source = source / 10;
			this.mant ~= digit;
		}
	}
	unittest {
    writeln("this(long) unittest");
    BigInt q = BigInt(0);
    assert(q.mant == [0]);

		BigInt num = BigInt(100);
		assert(num.mant == [0, 0, 1]);
		assert(num.sign == false);

		BigInt num2 = BigInt(-321);
		assert(num2.mant == [1, 2, 3]);
		assert(num2.sign == true);

		BigInt num3 = BigInt(0);
		assert(num3.mant == [0]);
		assert(num3.sign == false);

		BigInt num4 = BigInt(-0);
		assert(num4.mant == [0]);
		assert(num4.sign == false);

		num2 = BigInt(0);
		assert(num2.mant == [0]);
		assert(num2.sign == false);

		num = BigInt(0);
		assert(num.mant == [0]);
		assert(num.sign == false);

		BigInt a = BigInt(947436711);
		BigInt b = BigInt(3245879);
		assert(a.mant == [1, 1, 7, 6, 3, 4, 7, 4, 9]);
		assert(a.sign == false);
		assert(b.mant == [9, 7, 8, 5, 4, 2, 3]);
		assert(b.sign == false);
		a = BigInt(0);
		b = BigInt(0);
		assert(a.mant == [0]);
		assert(a.sign == false);
		assert(b.mant == [0]);
		assert(b.sign == false);
    writeln("this(long) unittest passed");
	}

  this(byte[] source, bool sign) nothrow {
		// Allows us to take a slice of an existing BigInt and encapsulate it in a new BigInt.
		// Use caution. The new BigInt refers to the same data as the source.

    this.mant = source;
    this.sign = sign;
  }

	this(const(byte)[] source, bool sign) nothrow {
		this.mant = source.dup;
    this.sign = sign;
	}
  unittest {
    writeln("this(byte[]) unittest");
	  auto c = BigInt("68630377364883");
    auto d = BigInt(c.mant, c.sign);
    BigInt e = c;
    c.mant[5] = 4;
    assert(c.mant == d.mant);
    assert(c.mant != e.mant);
    assert(c.mant is d.mant);
    assert(c.mant !is e.mant);
    writeln("this(byte[]) unittest passed");
  }

	this(this) nothrow {
		mant = mant.dup;
	}
	unittest {
    writeln("this(this) unittest");
		BigInt a = "777";
		BigInt b = "888";

		auto c = a;
		assert(c.toString() == "777");
		a = b;
		assert(a.toString() == "888");
    writeln("this(this) unittest passed");
	}

  auto ref BigInt opUnary(string op)() {
    static if (op == "++")
      return this.inc();
    else static if (op == "--")
      return this.dec();
    else static if (op == "-")
      return this.neg();
  }
  unittest {
    writeln("opUnary unittest");
    BigInt a = BigInt(-2);
    ++a;
    assert(a.toString() == "-1");
    a++;
    assert((a++).toString() == "0");
    assert(a.toString() == "1");
    a++;
    assert(a.toString() == "2");
    assert((--a).toString() == "1");
    a--;
    assert(a.toString() == "0");
    --a;
    assert(a.toString() == "-1");
    a--;
    assert(a.toString() == "-2");
    BigInt b = BigInt(9);
    b++;
    assert(b.toString() == "10");
    assert((--b).toString() == "9");
    assert((b--).toString() == "9");
    assert(b.toString() == "8");
    b++;
    assert((++b).toString() == "10");
    BigInt c = BigInt(-9);
    assert((--c).toString() == "-10");
    c++;
    assert(c.toString() == "-9");
    assert((-a).toString() == "2");
    assert((-b).toString() == "-10");
    assert((-c).toString() == "9");
    writeln("opUnary unittest passed");
  }

  //BigInt opBinary(string op, T)(T rhs)
  //if (isIntegral!T) {
    //static if (op == "^^")
      //return this.powFast(rhs);
    //else
      //return this.opBinary!op(BigInt(rhs).byRef());
  //}

  BigInt opBinary(string op, T)(auto ref const(T) rhs) const
  if (isIntegral!T || is(T == BigInt)) {
    static if (op == "+") {
      static if (is(T == BigInt))
        return this.add(rhs);
      else
        return this.add(BigInt(rhs).byRef());
    } else static if (op == "-") {
      static if (is(T == BigInt))
        return this.sub(rhs);
      else
        return this.sub(BigInt(rhs).byRef());
    } else static if (op == "*") {
      static if (is(T == BigInt))
        return this.mul(rhs);
      else
        return this.mul(BigInt(rhs).byRef());
    } else static if (op == "/") {
      static if (is(T == BigInt))
        return this.div(rhs);
      else
        return this.div(BigInt(rhs).byRef());
    } else static if (op == "%") {
      static if (is(T == BigInt))
        return this.mod(rhs);
      else
        return this.mod(BigInt(rhs).byRef());
    } else static if (op == "^^") {
      return this.powFast(rhs);
    }
  }

  bool opEquals(T)(const(T) rhs) const
  if (isIntegral!T) {
    return opEquals((BigInt(rhs)).byRef());
  }

  bool opEquals()(auto ref const(BigInt) rhs) const {
		if (this.mant == [0] && rhs.mant == [0]) {
			return true;
		}

		if (this.sign != rhs.sign)
			return false;

		if (this.mant.length != rhs.mant.length)
			return false;

		foreach(i; 0 .. this.mant.length) {
			if (this.mant[i] != rhs.mant[i])
				return false;
		}

		return true;
	}
	unittest {
    writeln("opEquals unittest");
		auto a = BigInt(18298);
		auto b = BigInt(327);
		auto c = BigInt(-2389893);
		auto d = BigInt(-8472);
		auto e = BigInt(42);
		auto f = BigInt(-18298);
		auto g = BigInt(42);
		auto h = BigInt(-8472);

		assert(a != f);
		assert(b != d);
		assert(c != f);
		assert(e == g);
		assert(d == h);
    writeln("opEquals unittest passed");
	}

  int opCmp(T)(T rhs) const
  if (isIntegral!T) {
    return this.opCmp((BigInt(rhs)).byRef());
  }

	int opCmp(ref const(BigInt) rhs) const {
		int res;

		if (this.mant == [0] && rhs.mant == [0]) {
			res = 0;
		} else if (this.sign != rhs.sign) {
			if (this.sign)
				res = -1;
			else
				res = 1;
		} else {
			res = this.cmpAbsOld(rhs);

			if (this.sign) {
				res = -res;
			}
		}
		
		return res;
	}
	unittest {
    writeln("opCmp unittest");
		auto a = BigInt(18298);
		auto b = BigInt(327);
		auto c = BigInt(-2389893);
		auto d = BigInt(-8472);
		auto e = BigInt(42);
		auto f = BigInt(-18298);
		auto g = BigInt(42);
		auto h = BigInt(-8472);

		assert(a > b);
		assert(a >= b);
		assert(c < d);
		assert(c <= d);
		assert(e < b);
		assert(e <= b);
		assert(e <= g);
		assert(f <= a);
		assert(f < a);
		assert(h < b);
		assert(h >= f);
    writeln("opCmp unittest passed");
	}

  void opAssign(T)(T rhs)
  if (isIntegral!T) {
    this = BigInt(rhs);
  }

  //void opAssign(T)(T rhs) {
    //this.mant = rhs.mant.dup;
    //this.sign = rhs.sign;
  //}

  void opOpAssign(string op, T)(T rhs)
  if (isIntegral!T) {
    BigInt value = BigInt(rhs);
    opOpAssign!op(value);
  }
  
	void opOpAssign(string op, T)(T rhs)
  if (is(T == BigInt)) {
      static if (op == "+")
        this = this.add(rhs);
      else static if (op == "-")
        this = this.sub(rhs);
      else static if (op == "*")
        this = this.mul(rhs);
      else static if (op == "/")
        this = this.div(rhs);
      else static if (op == "%")
        this = this.mod(rhs);
	}

	string mantissa() @property const {
    char[] mantissa = this.mant.map!(a => cast(char)(a + '0')).array();
    std.algorithm.reverse(mantissa);
    return cast(immutable)mantissa;
	}
	unittest {
    writeln("mantissa unittest");
    auto a = BigInt(12345);
    assert(a.mantissa == "12345");
    a = BigInt(54321);
    assert(a.mantissa == "54321");
    writeln("mantissa unittest passed");
	}

  string toString() const {
		byte[] str;
		str.length = mant.length;
		str[] = this.mant[] + '0';

		if (sign) {
			str ~= '-';
		}

    std.algorithm.reverse(str);

		return cast(string)(str);
	}	
	unittest {
    writeln("toString unittest");
		BigInt num = BigInt(321);
		assert(num.toString() == "321");

		BigInt num2 = BigInt(-536);
		assert(num2.toString() == "-536");
    writeln("toString unittest passed");
	}

  mixin RvalueRef;
}

byte[] toReverseBytes(string value) {
  return value.retro.map!(a => (a - 48).to!byte()).array();
}
unittest {
  writeln("toReverseBytes unittest");
  assert("2374".toReverseBytes() == [4, 7, 3, 2]);
  writeln("toReverseBytes unittest passed");
}

string toReverseString(const(byte)[] value) {
  return value.retro.map!(a => (a + 48).to!char()).array.idup();
}
unittest {
  writeln("toReverseString unittest");
  assert([4, 7, 3, 2].toReverseString() == "2374");
  writeln("toReverseString unittest passed");
}

int[] factorial(int[] digits) {
	int[] result = digits.dup;
	int[] multiplier = digits.dup;
	int[] subtrahend = "1".dup.toReverseIntArr;
	subtract(multiplier, subtrahend);

	while (multiplier.length != 1 || multiplier[0] != 0) {
		result = multiply(result, multiplier);
		subtract(multiplier, subtrahend);
	}

	return result;
}

int[] multiply(int[] digits, int[] multiplier) {
	int offset;
	int[] addend;
	int[] result;
	int carry;
	int dig;

	foreach (n; digits) {
		foreach (m; multiplier) {
			dig = m * n + carry;
			addend ~= dig % 10;
			carry = dig / 10;
		}
		if (carry) {
			addend ~= carry;
			carry = 0;
		}
		accumulate(result, addend, offset);
		addend.length = 0;
		offset++;
	}

	return result;
}

void accumulate(ref int[] result, int[] addend, int offset) {
	int carry;
	int digSum;
	int i = offset;

	if (result.length < addend.length + offset)
		result.length = addend.length + offset;

	auto resSlice = result[offset..$];

	foreach (int j, addDig; addend) {
		digSum = resSlice[j] + addDig + carry;
		resSlice[j] = digSum % 10;
		carry = digSum / 10;
		i++;
	}

	while (carry) {
		if (i < result.length) {
			digSum = result[i] + carry;
			result[i] = (digSum % 10);
			carry = digSum / 10;			
		} else {
			result ~= carry;
			carry = 0;
		}
		i++;
	}
}

void subtract(ref int[] digits, int[] subtrahend) {
	int borrow;
	int dig;
	int i;

	foreach (j, subDig; subtrahend) {
		dig = digits[j] - subDig - borrow;
		if (dig < 0) {
			dig += 10;
			borrow = 1;
		} else {
			borrow = 0;
		}
		digits[j] = dig;
		i++;
	}

	while (borrow) {
		dig = digits[i] - borrow;
		if (dig < 0) {
			dig += 10;
			borrow = 1;
		} else {
			borrow = 0;
		}
		digits[i++] = dig;	// Will give range violation if subtrahend is bigger than digits
	}

	while (digits[$ - 1] == 0 && digits.length > 1) {
		digits.length--;
	}
}

int[] toReverseIntArr(char[] cArr) {
  int[] iArr = cArr.map!(a => cast(int)(a - '0')).array();
	std.algorithm.reverse(iArr);
  return iArr;
}

char[] toReverseCharArr(int[] iArr) {
	char[] cArr = iArr.map!(n => cast(char)(n + '0')).array();
  std.algorithm.reverse(cArr);
	return cArr;
}


