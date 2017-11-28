module kreikey.bigint;

import std.algorithm;
import std.array;
import std.string;
//import std.conv;
import std.stdio;
import std.math;
import std.range;

struct BigInt {
private:
	byte[] mant = [];		// Blank default initializer allows us to build numbers digit by digit.
	bool sign = false;

	alias mant this;



	BigInt addAbs(BigInt rhs) {
		BigInt sum = BigInt();
		int carry;

		sum.length = this.length > rhs.length ? this.length : rhs.length;
		sum[0 .. this.length] = this.dup;
		sum[0 .. rhs.length] += rhs[];

		foreach(ref n; sum) {
			n += carry;
			carry = n / 10;
		}

		if (carry)
			sum ~= 1;

		sum[] %= 10;

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

	BigInt subAbs(BigInt rhs) {
		BigInt diff = BigInt();
		BigInt ninesComp = BigInt();

		if (this.cmpAbs(rhs) < 0)
			throw new Exception("Subtrahend of absolute subtraction is greater than minuend");

		ninesComp.length = this.length;
		ninesComp[] = 9;
		ninesComp[0 .. rhs.length] -= rhs[];
		diff = this.addAbs(ninesComp);
		diff = diff.addAbs(BigInt(1));
		do diff.length--;
		while(diff[$ - 1] == 0 && diff.length > 1);

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

  BigInt incAbs() {
    int carry;
    int n;
    
    this[0] += 1;
    n = this[0];

    while (n > 9) {
      n -= 10;
    }


    for (int i = 0; i < this.length; i++) {
      if (this[i] > 9) {
        this[i] -= 10;
        carry = 1;
      }
    }
  }

	int cmpAbs(const BigInt rhs) const {
		if (this.length < rhs.length)
			return -1;
		else if (this.length > rhs.length)
			return 1;

		foreach (i; retro(iota(0, this.length)))
			if (this[i] < rhs[i])
				return -1;
			else if (this[i] > rhs[i])
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

	BigInt karatsuba(BigInt rhs) {
		BigInt pro = BigInt();
		BigInt lowLeft = BigInt();
		BigInt highLeft = BigInt();
		BigInt lowRight = BigInt();
		BigInt highRight = BigInt();
		BigInt z0 = BigInt();
		BigInt z1 = BigInt();
		BigInt z2 = BigInt();
		byte n;
		ulong m;

		if (this.length < 2 || rhs.length < 2) {
			if (this.length < rhs.length) {
				pro.mant = rhs.dup;
				n = this[0];
			} else {
				pro.mant = this.dup;
				n = rhs[0];
			}

			return pro.mulSingleDigit(n);
		} 

		m = this.length > rhs.length ? this.length / 2 : rhs.length / 2;

		// Split and handle out-of-bounds indices
		highLeft = m >= this.length ? BigInt(0) : BigInt(this[m .. $]);
		lowLeft = m >= this.length ? this : BigInt(this[0 .. m]);
		highRight = m >= rhs.length ? BigInt(0) : BigInt(rhs[m .. $]);
		lowRight = m >= rhs.length ? rhs : BigInt(rhs[0 .. m]);

		// Handle leading zeros
		while (lowLeft[$ - 1] == 0 && lowLeft.length > 1)
			lowLeft.length--;
		while(lowRight[$ - 1] == 0 && lowRight.length > 1)
			lowRight.length--;

		z2 = highLeft.karatsuba(highRight);
		z0 = lowLeft.karatsuba(lowRight);
		z1 = lowLeft.addAbs(highLeft).karatsuba(lowRight.addAbs(highRight));

		pro = z2.mulPow10(2 * m)
				.addAbs(z1
					.subAbs(z2)
					.subAbs(z0)
					.mulPow10(m))
				.addAbs(z0);

		return pro;
	}

	// Multiplies by a power of 10
	BigInt mulPow10(ulong n) {
		BigInt copy = this;

		if (n < 1) {
			throw new Exception("mulPow10(num) is not supported for num < 1");
		}

		if (this[$ - 1] == 0)
			return copy;

		copy.length += n;

		foreach(i; retro(iota(n, copy.length)))
			copy[i] = copy[i - n];

		copy[0 .. n] = 0;

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
		byte[] quoMant;
		byte dig;
		int littleEnd, bigEnd;

		if (rhs == BigInt(0))
			throw new Exception("Divide by zero error.");
		if (this.cmpAbs(rhs) < 0) {
			//throw new Exception("DivMod of a bigger number not implemented yet.");
			quo = BigInt(0);
			mod = rhs;
			return;
		}

		// Needs to examine the lengths of each number and act accordingly.
		// We want this to work regardless of which side has the bigger number.
		// Division might yield 0, but it should *never* crash like it does now.
		// Modulus by a bigger number should yield the number itself.
		
		littleEnd = cast(int)(this.length - rhs.length);
		littleEnd = littleEnd > 0 ? littleEnd : 0;
		bigEnd = cast(int)(this.length);

		if (rhs.cmpAbs(BigInt(this[littleEnd .. bigEnd])) > 0 && littleEnd > 0) {
			littleEnd--;
		}

		divid = BigInt(this[littleEnd .. bigEnd]);
		
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
				divid = mod.mulPow10(1).addAbs(BigInt(this[littleEnd - 1]));
			}

		} while (littleEnd-- > 0);

		std.algorithm.reverse(quo.mant);

		// Fix up mod by taking negatives into account

		if (quo[$ - 1] == 0)
			quo.sign = false;
		else
			quo.sign = this.sign != rhs.sign;
		if (mod[$ - 1] == 0)
			mod.sign = false;
		else
			mod.sign = this.sign;
}

public:
	this(string source) {
		bool allZeros = true;

		if (source[0] == '-') {
			this.sign = true;
			source = source[1 .. $];
		}

		foreach (c; source) {
			if (c < '0' || c > '9')
				throw new Exception("String is not a valid integer");
			if (c != '0')
				allZeros = false;
		}

		this.length = source.length;
		this[] = cast(byte[])(source);
		this[] -= '0';
		std.algorithm.reverse(this.mant);

		if (this.length >= 1 && allZeros)
			this.length = 1;
	}
	unittest {
		BigInt num = BigInt("100");
		assert(num.mant == [0, 0, 1]);
		assert(num.sign == false);

		BigInt num2 = BigInt("-321");
		assert(num2.mant == [1, 2, 3]);
		assert(num2.sign == true);
	}

	this(long source) {
		byte digit;

		this.length = 1;
		this[0] = 0;
		this.sign = false;

		if (source != 0)
			this.length = 0;

		if (source < 0)
			this.sign = true;

		source = abs(source);

		while (source > 0) {
			digit = source % 10;
			source = source / 10;
			this ~= digit;
		}
	}
	unittest {
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

	this(byte[] source) {
		// Allows us to take a slice of an existing BigInt and encapsulate it in a new BigInt.
		// Use caution. The new BigInt refers to the same data as the source.

		this.mant = source;
		this.length = source.length;
	}
	
	this(this) {
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
		BigInt sum = BigInt();

		if (this.sign == rhs.sign) {
			sum = this.addAbs(rhs);
			sum.sign = this.sign;
		} else {
			if (this.cmpAbs(rhs) > 0) {
				sum = this.subAbs(rhs);
				sum.sign = this.sign;
			} else if (this.cmpAbs(rhs) < 0) {
				sum = rhs.subAbs(this);
				sum.sign = rhs.sign;
			}
		}

		if (sum[$ - 1] == 0)
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
	
		if (diff[$ - 1] == 0)
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

	BigInt mul(BigInt rhs) {
		BigInt pro = this.karatsuba(rhs);

		if (pro[$ - 1] == 0)
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

		auto z = a.div(b);
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

	BigInt pow(BigInt rhs) {
		auto pow = BigInt();
		// We need a way to *efficiently* increment a BigInt. It needs to work for positive and negative.
		// We need to overload the increment and decrement operators. It needs to make no copies.
		// Pre-increment and pre-decrement can satisfy this. Post needs to make a copy.

		return pow;
	}

	BigInt pow(ulong rhs) {
		BigInt product;
		ulong counter = 1;

		if (rhs == 0) {
			product = BigInt(0);
			return product;
		}

		product = this;

		while (counter++ < rhs) {
			product = this.mul(product);
		}

		return product;
	}


/*	BigInt opSlice()(size_t start, size_t end) {
		BigInt slice = this;
		slice.mant = this.mant[start .. end];
		writeln("yup, we called opSlice.");
		return slice;
	}

	ulong opDollar()() {
		writeln("yup, we called opDollar.");
		return this.mant.length;
	}
*/
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
		//else static if (op == "^^")
			//return this.pow(rhs);
	}

	BigInt opBinary(string op)(ulong rhs) {
		static if (op == "^^") {
			return this.pow(rhs);
		}
	}

	bool opEquals()(auto ref const BigInt rhs) const {
		if (this.mant == [0] && rhs.mant == [0]) {
			return true;
		}

		if (this.sign != rhs.sign)
			return false;

		if (this.length != rhs.length)
			return false;

		foreach(i; 0 .. this.length) {
			if (this[i] != rhs[i])
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

	void opOpAssign(string op)(BigInt rhs) {
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
    char[] mantcp = cast(char[])mant.dup; 
    mantcp[] += '0';
    std.algorithm.reverse(mantcp);
    return mantcp.idup;
	}
	unittest {

	}

  string toString() const {
		byte[] str;
		str.length = mant.length;
		str[] = mant[] + '0';

		if (sign) {
			str ~= '-';
		}

    std.algorithm.reverse(str);

		return cast(string)(str);
	}	
	unittest {
		BigInt num = BigInt(321);
		assert(strip(num.toString()) == "321");

		BigInt num2 = BigInt(-536);
		assert(strip(num2.toString()) == "-536");
	}
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
