module kreikey.bigint;

import std.algorithm;
import std.array;
import std.string;
//import std.conv;
import std.stdio;
import std.math;
import std.range;
import std.traits;

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
	//alias mant this;

	BigInt addAbs(BigInt rhs) {
		BigInt sum = BigInt();
		int carry = 0;

		sum.mant.length = this.mant.length > rhs.mant.length ? this.mant.length : rhs.mant.length;
		sum.mant[0 .. this.mant.length] = this.mant[];
		sum.mant[0 .. rhs.mant.length] += rhs.mant[];
    sum.mant[1 .. $] += sum.mant[0 .. $-1] / 10;
    carry = sum.mant[$-1] / 10;
		sum.mant[] %= 10;

		if (carry)
			sum.mant ~= 1;

		return sum;
	}
	unittest {
		BigInt a = BigInt(947436711);
		BigInt b = BigInt(3245879);		
		BigInt c = BigInt();

		c = a.addAbs(b);
		assert(c.toString() == "950682590");
		c = b.addAbs(a);
		assert(c.toString() == "950682590");
		BigInt d = BigInt(999);
		BigInt e = BigInt(1);
		c = d.addAbs(e);
		assert(c.toString() == "1000");
		c = e.addAbs(d);
		assert(c.toString() == "1000");
		a = BigInt(1);
		b = BigInt(1);
		c = a.addAbs(b);
		assert(c.toString() == "2");
		a = BigInt(0);
		b = BigInt(0);
		assert(a.mant == [0]);
		assert(b.mant == [0]);
		c = a.addAbs(b);
		assert(c.toString() == "0");
		a = BigInt(0);
		b = BigInt(1);
		c = a.addAbs(b);
		assert(c.toString() == "1");
		a = BigInt(9);
		b = BigInt(1);
		c = a.addAbs(b);
		assert(c.toString() == "10");
	}

  static byte[] addAbs2(byte[] big, byte[] little) {
    byte[] sum;
    int i = 0;
    byte carry = 0;

    //if (cmpAbs2(big, little) < 0)
      //throw new Exception("the left operand needs to be bigger than the right operand");

    sum.reserve(big.length + 1);
    
    do {
      sum ~= cast(byte)(little[i] + big[i] + carry);
      if (sum[i] > 9) {
        carry = 1;
        sum[i] -= 10;
      } else {
        carry = 0;
      }
    } while (++i < little.length);

    while (i < big.length) {
      sum ~= cast(byte)(big[i] + carry);
      if (sum[i] > 9) {
        carry = 1;
        sum[i] -= 10;
      } else {
        carry = 0;
      }
      i++;
    }

    if (carry) {
      sum ~= carry;
    }

    return sum;
  }
  unittest {
    byte[] s = addAbs2([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    //writeln(s);
    assert(s == [5, 0, 2, 5, 9]);
    s = addAbs2([1, 3, 8, 2, 9], [4, 7, 3, 2]);
    s = addAbs2([1, 3, 8, 2, 9], [4, 7, 3, 2, 7]);
    //writeln(s);
    assert(s == [5, 0, 2, 5, 6, 1]);
  }

	BigInt subAbs(BigInt rhs) {
		BigInt diff = BigInt();
		BigInt ninesComp = BigInt();

		//if (this.cmpAbs(rhs) < 0)
			//throw new Exception("Subtrahend of absolute subtraction is greater than minuend");

		ninesComp.mant.length = this.mant.length;
		ninesComp.mant[] = 9;
		ninesComp.mant[0 .. rhs.mant.length] -= rhs.mant[];
		diff = this
      .addAbs(ninesComp)
      .incAbs();
		do diff.mant.length--;
		while(diff.mant[$ - 1] == 0 && diff.mant.length > 1);

		return diff;
	}
	unittest {
		BigInt c = BigInt();
		BigInt b = BigInt(3245879);
		BigInt a = BigInt(950682590);

		c = a.subAbs(b);
		assert(c.toString() == "947436711");
		a = BigInt(20);
		b = BigInt(20);
		c = a.subAbs(b);
		assert(c.toString() == "0");
		a = BigInt(0);
		b = BigInt(0);
		c = a.subAbs(b);
		assert(c.toString() == "0");
	}

  static byte[] subAbs2(byte[] big, byte[] little) {
    byte[] diff;
    byte borrow = 0;
    byte i = 0;

		//if (cmpAbs2(big, little) < 0)
			//throw new Exception("Subtrahend of absolute subtraction is greater than minuend");

    diff.reserve(big.length);

    do {
      diff ~= cast(byte)(big[i] - little[i] - borrow);
      if (diff[i] < 0) {
        diff[i] += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
    } while(++i < little.length);

    while(i < big.length) {
      diff ~= cast(byte)(big[i] - borrow);
      if (diff[i] < 0) {
        diff[i] += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
      i++;
    }

    while (diff[$-1] == 0 && diff.length > 1)
      diff.length--;

    return diff;
  }
  unittest {
    byte[] a = [0, 0, 1];
    byte[] b = [1, 1];

    assert(subAbs2(a, b) == [9, 8]);
    a = [1];
    b = [1];
    assert(subAbs2(a, b) == [0]);
    a = [0, 0, 1];
    b = [9, 9];
    assert(subAbs2(a, b) == [1]);
  }

  ref BigInt incAbs() {
    int carry = 0;
    //writeln(this); 
    this.mant[0] += 1;

    foreach (ref d; this.mant) {
      d += carry;
      if (d == 10) {
        d = 0;
        carry = 1;
      } else {
        carry = 0;
        break;
      }
    }

    if (carry) {
      this.mant ~= 1;
    }
    return this;
  }
  unittest {
    BigInt a = BigInt(0);
    a.incAbs();
    //writeln(a);
    assert(a.toString() == "1");
    a = BigInt(9);
    a.incAbs();
    //writeln(a);
    assert(a.toString() == "10");
    a = BigInt(999);
    a.incAbs();
    //writeln(a);
    assert(a.toString() == "1000");
  }

  ref BigInt decAbs() {
    bool borrow = false;

    if (this.cmpAbs(BigInt(1)) < 0)
        throw new Exception("can't call decAbs() on a number whose absolute value is less than 1");

    ulong i = 0;

    do {
      if (this.mant[i] > 0) {
        this.mant[i]--;
        borrow = false;
      } else {
        this.mant[i] = 9;
        borrow = true;
      }
      i++;
    } while (borrow);

    if (this.mant[$ - 1] == 0 && this.mant.length > 1)
      this.mant.length--;

    return this;
  }
  unittest {
    BigInt a = BigInt(2);
    a.decAbs();
    assert(a.toString() == "1");
    a.decAbs();
    assert(a.toString() == "0");
    BigInt b = BigInt(1000);
    b.decAbs();
    assert(b.toString() == "999");
    b.decAbs();
    assert(b.toString() == "998");
    BigInt c = BigInt(11);
    c.decAbs();
    assert(c.toString() == "10");
    c.decAbs();
    assert(c.toString() == "9");
    BigInt d = BigInt(-7);
    d.decAbs();
    assert(d.toString() == "-6");
  }

	int cmpAbs(const BigInt rhs) const {
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
	unittest{
		BigInt a = BigInt(234);
		BigInt b = BigInt(969);
		BigInt c = BigInt(-1293);
		BigInt d = BigInt(45);
		BigInt e = BigInt(-969);
		BigInt f = BigInt(1199);

		assert(a.cmpAbs(b) < 0);
		assert(b.cmpAbs(a) > 0);
		assert(c.cmpAbs(d) > 0);
		assert(d.cmpAbs(c) < 0);
		assert(c.cmpAbs(d) > 0);
		assert(b.cmpAbs(e) == 0);
		assert(c.cmpAbs(f) > 0);
		assert(f.cmpAbs(c) < 0);
	}

  static int cmpAbs2(byte[] left, byte[] right) {
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
	unittest{
		byte[] a = [2, 3, 4];
		byte[] b = [9, 6, 9];
		byte[] c = [1, 2, 9, 3];
		byte[] d = [4, 5];
		byte[] e = [9, 6, 9];
		byte[] f = [1, 1, 9, 9];

		assert(cmpAbs2(a, b) < 0);
		assert(cmpAbs2(b, a) > 0);
		assert(cmpAbs2(c, d) > 0);
		assert(cmpAbs2(d, c) < 0);
		assert(cmpAbs2(c, d) > 0);
		assert(cmpAbs2(b, e) == 0);
		assert(cmpAbs2(c, f) < 0);
		assert(cmpAbs2(f, c) > 0);
	}

	BigInt karatsuba(BigInt rhs) {
		BigInt lowLeft = BigInt();
		BigInt highLeft = BigInt();
		BigInt lowRight = BigInt();
		BigInt highRight = BigInt();
		BigInt z0 = BigInt();
		BigInt z1 = BigInt();
		BigInt z2 = BigInt();
		byte n;
		ulong m;

    // Take care of base case where one or both operands are of length 1
    if (this.mant.length == 1) {
      return rhs.mulSingleDigit(this.mant[0]);
    } else if (rhs.mant.length == 1) {
      return this.mulSingleDigit(rhs.mant[0]);
    }

		m = this.mant.length > rhs.mant.length ? this.mant.length / 2 : rhs.mant.length / 2;

		// Split and handle out-of-bounds indices
		highLeft = m >= this.mant.length ? BigInt(0) : BigInt(this.mant[m .. $]);
		lowLeft = m >= this.mant.length ? this : BigInt(this.mant[0 .. m]);
		highRight = m >= rhs.mant.length ? BigInt(0) : BigInt(rhs.mant[m .. $]);
		lowRight = m >= rhs.mant.length ? rhs : BigInt(rhs.mant[0 .. m]);

		// Handle leading zeros
		while (lowLeft.mant[$ - 1] == 0 && lowLeft.mant.length > 1)
			lowLeft.mant.length--;
		while(lowRight.mant[$ - 1] == 0 && lowRight.mant.length > 1)
			lowRight.mant.length--;

		z2 = highLeft.karatsuba(highRight);
		z0 = lowLeft.karatsuba(lowRight);
		z1 = lowLeft.addAbs(highLeft).karatsuba(lowRight.addAbs(highRight));

		return z2.mulPow10(2 * m)
				.addAbs(z1
					.subAbs(z2)
					.subAbs(z0)
					.mulPow10(m))
				.addAbs(z0);
	}

	// Multiplies by a power of 10
	BigInt mulPow10(ulong n) {
		BigInt copy = this;

		if (n < 1) {
			throw new Exception("mulPow10(num) is not supported for num < 1");
		}

		if (this.mant[$ - 1] == 0)
			return copy;

		copy.mant.length += n;

		foreach(i; retro(iota(n, copy.mant.length)))
			copy.mant[i] = copy.mant[i - n];

		copy.mant[0 .. n] = 0;

		return copy;
	}
	unittest {
		auto a = BigInt(1234);
		auto b = BigInt(4000);
		BigInt c;

		c = a.mulPow10(5);
		assert(c.toString() == "123400000");
		c = b.mulPow10(2);
		assert(c.toString() == "400000");
		c = a.mulPow10(1);
		assert(c.toString() == "12340");
		a = BigInt(20);
		c = a.mulPow10(2);
		assert(c.toString() == "2000");
	}

	BigInt mulSingleDigit(byte n) {
		BigInt pro = this;
		byte carry;

		pro.mant[] *= n;

		foreach (ref a; pro.mant) {
			a += carry;
			carry = a / 10;
		}

		if (carry)
			pro.mant ~= carry;

		pro.mant[] %= 10;

		// In case we've multiplied by a zero, set length to one.
		if (pro.mant[$ - 1] == 0)
			pro.mant.length = 1;

		return pro;
	}
	unittest {
		auto a = BigInt(23432);
		auto b = BigInt(87263);
		auto c = BigInt(-32786);
		auto d = BigInt(0);
		BigInt r;
		byte w = 0;
		byte x = 4;
		byte y = 9;
		byte z = 3;

		assert(a.mulSingleDigit(x).toString() == "93728");
		//writeln(a.mulSingleDigit(y).toString());
		assert(a.mulSingleDigit(y).toString() == "210888");
		assert(a.mulSingleDigit(z).toString() == "70296");
		assert(b.mulSingleDigit(x).toString() == "349052");
		assert(b.mulSingleDigit(y).toString() == "785367");
		assert(b.mulSingleDigit(z).toString() == "261789");
		assert(c.mulSingleDigit(x).toString() == "-131144");
		assert(c.mulSingleDigit(y).toString() == "-295074");
		assert(c.mulSingleDigit(z).toString() == "-98358");
		assert(d.mulSingleDigit(w).toString() == "0");
		assert(d.mulSingleDigit(x).toString() == "0");
		assert(d.mulSingleDigit(y).toString() == "0");
		assert(d.mulSingleDigit(z).toString() == "0");
		assert(a.mulSingleDigit(w).toString() == "0");
		assert(b.mulSingleDigit(w).toString() == "0");
		assert(c.mulSingleDigit(w).toString() == "-0");
	}

  void divMod(BigInt rhs, ref BigInt quo, ref BigInt mod) {
		BigInt acc;
		BigInt divid;
		//byte[] quoMant;
		byte dig;
		int littleEnd, bigEnd;

		if (rhs == BigInt(0))
			throw new Exception("Divide by zero error.");
		if (this.cmpAbs(rhs) < 0) {
			quo = BigInt(0);
			mod = rhs;
			return;
		}

		// Needs to examine the lengths of each number and act accordingly.
		// We want this to work regardless of which side has the bigger number.
		// Division might yield 0, but it should *never* crash like it does now.
		// Modulus by a bigger number should yield the number itself.
		
		littleEnd = cast(int)(this.mant.length - rhs.mant.length);
		littleEnd = littleEnd > 0 ? littleEnd : 0;
		bigEnd = cast(int)(this.mant.length);

		if (rhs.cmpAbs(BigInt(this.mant[littleEnd .. bigEnd])) > 0 && littleEnd > 0) {
			littleEnd--;
		}

		divid = BigInt(this.mant[littleEnd .. bigEnd]);
		
    // We're building up the quotient digit-by-digit, so the length of the mantissa must be 0
    quo.mant.length = 0;

		do {
			dig = 0;
			acc = rhs;

			while (acc.cmpAbs(divid) <= 0) {
				dig++;
				acc = acc.addAbs(rhs);
			}

			quo.mant ~= dig;
			mod = divid.subAbs(acc.subAbs(rhs));

			if (littleEnd > 0) { 
				divid = mod.mulPow10(1).addAbs(BigInt(this.mant[littleEnd - 1]));
			}

		} while (littleEnd-- > 0);

		std.algorithm.reverse(quo.mant);

		// Fix up mod by taking negatives into account

		if (quo.mant[$ - 1] == 0)
			quo.sign = false;
		else
			quo.sign = this.sign != rhs.sign;
		if (mod.mant[$ - 1] == 0)
			mod.sign = false;
		else
			mod.sign = this.sign;
  }

  BigInt powFast(T)(T exp)
  if (isIntegral!T || is(T == BigInt)) {
    T remainder = 0;

    if (exp < 0) {
      throw new Exception("It's an integer library, not a fraction or floating point library. No negative exponents allowed!");
    } else if (exp == 0) {
      return BigInt(1);
    } else if (exp == 1) {
      return this;
  // If I make it fully generic like this, I need to provide an efficient divMod function that won't calculate divMod twice.
    // I.e. I need to make divMod cache the result of the last operation and query whether we're using the same operands as last time.
    }

    remainder = exp % 2;
    exp /= 2;
    return powFast(exp + remainder) * powFast(exp);
  }
  unittest {
    BigInt a = 2;
    assert(a.toString() == "2");
    BigInt b = 5;
    assert(b.toString() == "5");
    BigInt c = 3;
    BigInt z = a.powFast(13);
    assert(z.toString() == "8192");
    z = b.powFast(13);
    assert(z.toString() == "1220703125");
    BigInt y = c.powFast(29);
    assert(y.toString() == "68630377364883");
    BigInt e = 13;
    assert(e.powFast(11).toString() == "1792160394037");
    assert(e.powFast(14).toString() == "3937376385699289");
  }

public:
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
    //writeln("this(string source) unittest:");
		BigInt num = BigInt("100");
		assert(num.mant == [0, 0, 1]);
		assert(num.sign == false);

		BigInt num2 = BigInt("-321");
		assert(num2.mant == [1, 2, 3]);
		assert(num2.sign == true);
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
    //writeln("this(long source) unittest:");
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
	}

	this(byte[] source) nothrow {
		// Allows us to take a slice of an existing BigInt and encapsulate it in a new BigInt.
		// Use caution. The new BigInt refers to the same data as the source.

		this.mant = source;
		this.mant.length = source.length;
	}
  unittest {
    //writeln("this(byte[] source) unittest:");
	  auto c = BigInt("68630377364883");
    auto d = BigInt(c.mant);
    BigInt e = c;
    c.mant[5] = 4;
    assert(c.mant == d.mant);
    assert(c.mant != e.mant);
    assert(c.mant is d.mant);
    assert(c.mant !is e.mant);
    //writefln("c: %s, d: %s", c, d);
    //writefln("c.mant is d.mant? %s", c.mant is d.mant);
    //c[0] = 5;
    //writefln("c: %s, e: %s", c, e);
    //writefln("c.mant is e.mant? %s", c.mant is e.mant);
    //writeln("end unittest");
  }

	this(this) nothrow {
    //writefln("postblit called!");
		mant = mant.dup;
	}
	unittest {
		BigInt a = "777";
		BigInt b = "888";

		auto c = a;
		assert(c.toString() == "777");
		a = b;
		assert(a.toString() == "888");
	}

  BigInt add(BigInt rhs) {
		BigInt sum;

    int cmpRes = cmpAbs2(this.mant, rhs.mant);
    byte[] big = cmpRes < 0 ? rhs.mant : this.mant;
    byte[] little = cmpRes >= 0 ? rhs.mant : this.mant;

		if (this.sign == rhs.sign) {
			sum.mant = addAbs2(big, little);
			sum.sign = this.sign;
		} else
      sum.mant = subAbs2(big, little);
			if (cmpRes > 0)
				sum.sign = this.sign;
			else if (cmpRes < 0)
				sum.sign = rhs.sign;

		if (sum.mant[$ - 1] == 0)
			sum.sign = false;

		return sum;
	}
	unittest {
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
    //writeln(e);
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
	}

	BigInt sub(BigInt rhs) {
		BigInt diff = BigInt();

		if (this.sign == rhs.sign) {
			if (this.cmpAbs(rhs) > 0) {
				diff = this.subAbs(rhs);
				diff.sign = this.sign;
			} else if (this.cmpAbs(rhs) < 0) {
				diff = rhs.subAbs(this);
				diff.sign = !this.sign;
			}
		} else {
			diff = this.addAbs(rhs);
			diff.sign = this.sign;
		}
	
		if (diff.mant[$ - 1] == 0)
			diff.sign = false;

		return diff;
	}
	unittest {
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
	}

  ref BigInt inc() {
    if (this.sign) {
      this.decAbs();
    } else {
      this.incAbs();
    }

    if (this.mant[$ - 1] == 0)
      this.sign = false;

    return this;
  }
  unittest {
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
  }

  ref BigInt dec() {
    if (this.sign) {
      this.incAbs();
    } else if (this.mant[$ - 1] == 0) {
      this.incAbs();
      this.sign = true;
    } else {
      this.decAbs();
    }

    if (this.mant[$ - 1] == 0)
      this.sign = false;

    return this;
  }
  unittest {
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
  }

	BigInt mul(BigInt rhs) {
    //writefln("multiply. lhs: %s rhs: %s", this, rhs);
    //writefln("lhs is rhs? %s", this is rhs);
		BigInt pro = this.karatsuba(rhs);

		if (pro.mant[$ - 1] == 0)
			pro.sign = false;
		else
			pro.sign = this.sign != rhs.sign;

		return pro;
	}
	unittest {
		auto a = BigInt(999);
		auto b = BigInt(9);

		auto c = a.mul(b);
		assert(c.toString() == "8991");
		a = BigInt(20);
		b = BigInt(100);
		c = a.mul(b);
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
	}

	BigInt div(BigInt rhs) {
		BigInt quo = BigInt();
		BigInt mod = BigInt();

		this.divMod(rhs, quo, mod);

		return quo;
	}
	unittest {
		auto a = BigInt(476);
		auto b = BigInt(12);
		auto d = BigInt(23803671638400872);
		auto e = BigInt(4871830);
		auto f = BigInt(100);
		auto g = BigInt(-8271);
		auto h = BigInt(0);

		auto z = a.div(b);  // if we initialize to 0, this unittest fails. Why?
    // bug fixed. DivMod builds up its mantissa digit by digit, so it's mantissa length
    // must initially be 0. DivMod now sets it to 0 before building the mantissa.
		//writeln(z);
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
		/*try {
			z = g.div(h);
		} catch(Exception err) {
			writeln(err.message);
		}*/
	}

	BigInt mod(BigInt rhs) {
		BigInt mod = BigInt();
		BigInt quo = BigInt();

		this.divMod(rhs, quo, mod);

		return mod;
	}
	unittest {
		auto a = BigInt(476);
		auto b = BigInt(12);
		auto c = BigInt(23803671638400872);
		auto d = BigInt(4871830);
		auto e = BigInt(-23803671638400872);
		auto f = BigInt(-4871830);
		auto g = BigInt(120);
		auto h = BigInt(-8271);
		auto i = BigInt(0);

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
	}

  ref BigInt opUnary(string op)() {
    static if (op == "++")
      return this.inc();
    else static if (op == "--")
      return this.dec();
  }
  unittest {
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
  }

  BigInt opBinary(string op, T)(T rhs)
  if (isIntegral!T) {
    static if (op == "^^")
      return this.powFast(rhs);
    else
      return opBinary!op(BigInt(rhs));
  }

  BigInt opBinary(string op)(BigInt rhs) {
    static if (op == "+")
      return this.add(rhs);
    else static if (op == "-")
      return this.sub(rhs);
    else static if (op == "*")
      return this.mul(rhs);
    else static if (op == "/")
      return this.div(rhs);
    else static if (op == "%")
      return this.mod(rhs);
    else static if (op == "^^")
      return this.powFast(rhs);
  }

  bool opEquals(T)(T rhs) 
  if (isIntegral!T) {
    return opEquals((BigInt(rhs)).byRef());
  }

	bool opEquals()(auto ref const BigInt rhs) const {
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
	}

  int opCmp(T)(T rhs) const
  if (isIntegral!T) {
    return this.opCmp((BigInt(rhs)).byRef());
  }

	int opCmp(ref const BigInt rhs) const {
		int res;

		if (this.mant == [0] && rhs.mant == [0]) {
			res = 0;
		} else if (this.sign != rhs.sign) {
			if (this.sign)
				res = -1;
			else
				res = 1;
		} else {
			res = this.cmpAbs(rhs);

			if (this.sign) {
				res = -res;
			}
		}
		
		return res;
	}
	unittest {
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
	}

  void opAssign(T)(T rhs)
  if (isIntegral!T) {
    this = BigInt(rhs);
  }

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
    auto a = BigInt(12345);
    assert(a.mantissa == "12345");
    a = BigInt(54321);
    assert(a.mantissa == "54321");
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
		BigInt num = BigInt(321);
		assert(num.toString() == "321");

		BigInt num2 = BigInt(-536);
		assert(num2.toString() == "-536");
	}

  mixin RvalueRef;
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


