// From bigint.d; Uses the old method of having a BigInt for everything
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

// From bigint.d; This code isn't used.
  static byte[] addDigitInPlace(ref byte[] lhs, uint dig) {
    uint carry = 0;
    uint i = 0;

    lhs[i] += dig;

    do {
      lhs[i] += carry;
      if (lhs[i] > 9) {
        lhs[i] -= 10;
        carry = 1;
      } else {
        carry = 0;
      }
    } while(carry && ++i < lhs.length);

    if (carry)
      lhs ~= 1;

    return lhs;
  }
  unittest {
    byte[] a = "5421".rbytes();
    addDigitInPlace(a, 5);
    assert(a.rstr() == "5426");
    addDigitInPlace(a, 9);
    assert(a.rstr() == "5435");
    byte[] b = "999".rbytes();
    addDigitInPlace(b, 1);
    assert(b.rstr() == "1000");
  }

  static byte[] addDigit(const(byte[]) lhs, uint dig) {
    byte[] temp = lhs.dup;
    addDigitInPlace(temp, dig);
    return temp;
  }

  //static byte[] addAbsInPlace(ref byte[] lhs, const(byte[]) rhs) {
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

  //static byte[] subAbsInPlace(ref byte[] lhs, const(byte[]) rhs) {
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

// From Karatsuba
    // Functional style with UFCS, everything BigInt, or helper functions defined outside of struct.
		//return z2.shiftBig(2 * m)
				//.addAbs(z1
					//.subAbs(z2)
					//.subAbs(z0)
					//.shiftBig(m))
				//.addAbs(z0);

    // Functional style with no UFCS
    //return addAbs(
      //addAbs(
        //shiftBig(z2, 2 * m), 
        //shiftBig(
          //subAbs(
            //subAbsInPlace(z1, z2),
            //z0),
          //m)),
      //z0);
    //writefln("lhs: %s; rhs: %s;", lhs, rhs);
    //writefln("m: %s", m);
    //writefln("lowleft: %s highleft %s", lowLeft, highLeft);
    //writefln("lowRight: %s highRight %s", lowRight, highRight);
    //writefln("z0: %s, z1: %s, z2: %s", z0, z1, z2);

// From DivMod
    // It's probably better to return a (BigInt, BigInt) pair rather than a pair of byte[]s because I need to calculate signs somewhere.
    // If I calculate divMod in one place, I might as well calculate the signs in the same place.
    // Now, I could theoretically calculate them in div() and mod() respectively, but then I would need to look at the signs of the operands.
    // Actually, that might be just as good. Then when I implement caching of the last divMod operation, I could take that into account.
    // I could look only at the byte[]s of each cached operand, then consider the signs of the actual operand.
    // Or I would just look at the BigInt operands.

// From the end of bigint.d; It should probably go in intMath.d

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



void karatsuba(ref const byte[] lhs, ref const byte[] rhs) {
  byte[] z0;
  byte[] z1;
  byte[] z2;
  byte n;
  ulong m;

  // Take care of base case where one or both operands are of length 1
  if (lhs.length == 1) {
    result = rhs.dup;
    return mulSingleDigit(rhs, lhs[0]);
  } else if (rhs.length == 1) {
    result = lhs.dup;
    return mulSingleDigit(lhs, rhs[0]);
  }

  m = lhs.length > rhs.length ? lhs.length / 2 : rhs.length / 2;

  // Split and handle out-of-bounds indices
  auto highLeft = m >= lhs.length ? cast(byte[])[0] : lhs[m .. $];
  auto lowLeft = m >= lhs.length ? lhs : lhs[0 .. m];
  auto highRight = m >= rhs.length ? cast(byte[])[0] : rhs[m .. $];
  auto lowRight = m >= rhs.length ? rhs : rhs[0 .. m];

  // Handle leading zeros
  while (lowLeft[$ - 1] == 0 && lowLeft.length > 1)
    lowLeft.length--;
  while(lowRight[$ - 1] == 0 && lowRight.length > 1)
    lowRight.length--;

  z2 = karatsuba(highLeft, highRight);
  z0 = karatsuba(lowLeft, lowRight);
  auto leftSum = addAbs(lowLeft, highLeft);
  auto rightSum = addAbs(lowRight, highRight);
  z1 = karatsuba(leftSum, rightSum);

  // Imperative style. Really efficient.
  subAbsInPlace(z1, z2);
  subAbsInPlace(z1, z0);
  shiftBigInPlace(z1, m);
  shiftBigInPlace(z2, 2 * m);
  addAbsInPlace(z2, z1);
  addAbsInPlace(z2, z0);
  return z2;
}

string mantissa() @property const {
  return this.mant
    .retro
    .map!(a => (a + 48).to!char())
    .array
    .idup;
}
unittest {
  writeln("mantissa unittest");
  auto a = BigInt(12345);
  assert(a.mantissa == "12345");
  a = BigInt(54321);
  assert(a.mantissa == "54321");
  writeln("mantissa unittest passed");
}


