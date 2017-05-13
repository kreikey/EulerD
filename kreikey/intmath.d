module kreikey.intmath;

import kreikey.bigint;

long[] getFactors(long number) {
	static long[][long] factorsCache;
	long[] factors;
	long[] factorsBig;
	long big = number;
	long fac = 1;
	long temp;

	if (number in factorsCache)
		return factorsCache[number];

	factors ~= fac;
	fac++;

	while (fac < big) {
		if (number % fac == 0) {
			factors ~= fac;
			big = number / fac;
			if (fac != big)
				factorsBig ~= big;
		}
		fac++;
	}

	factors ~= factorsBig.reverse;
	factorsCache[number] = factors;

	return factors;
}


ulong mulOrder(ulong a, ulong n) {
	ulong order = 1;
	auto product = BigInt(a);
	auto one = BigInt(1);
	auto y = BigInt(a);
	auto z = BigInt(n);

	while (product % z != one) {
		order++;
		product *= y;
	}

	return order;
}

ulong carmichael(ulong n) {
	ulong a = 2;
	ulong order = 1;
	ulong bigOrder = 1;

	while (a < n) {
		if (areCoprime(a, n)) {
			order = mulOrder(a, n);

			if (order > bigOrder)
				bigOrder = order;
		}

		a++;
	}

	return bigOrder;
}

bool areCoprime(ulong a, ulong b) {
	ulong t;

	while (b != a) {
		if (a > b)
			a = a - b;
		else
			b = b - a;
	}

	return b == 1;
}

ulong gcdOld(ulong a, ulong b) {
	ulong t;

	while (b != 0) {
		t = b;
		b = a % b;
		a = t;
	}

	return a;
}

// gcd with subtraction is about twice as fast as gcd with modulo
ulong gcd(ulong a, ulong b) {
	ulong t;

	while (b != a) {
		if (a > b)
			a = a - b;
		else
			b = b - a;
	}

	return b;
}


ulong lcm(ulong a, ulong b) {
	ulong amul = a;
	ulong bmul = b;

	while (amul != bmul) {
		if (amul < bmul)
			amul += a;
		else if (bmul < amul)
			bmul += b;
	}

	return amul;
}

string recipDigits(int divisor, int length) {
	int dividend = 10;
	int quotient = 0;
	int remainder = 0;
	int digitCount = 0;
	byte[] digits;

	do {
		quotient = dividend / divisor;
		remainder = dividend % divisor;
		dividend = remainder * 10;
		digits ~= cast(byte)quotient;
		digitCount++;
	} while (remainder != 0 && digitCount != length);

	digits[] += '0';

	return cast(string)digits;
}

Factor[] primeFactorsOld(int num) {
	Factor[] factorsMultiplicity;
	int n = 2;
	int m = 0;

	while (num > 1) {

		if (num % n == 0) {
			do {
				m++;
				num /= n;
			} while (num % n == 0);

			//writefln("factor: %s multiplicity %s ", n, m);
			factorsMultiplicity ~= Factor(n, m);			
		}

		//writefln("%s is divisible by %s with multiplicity %s", num, n, m);

		m = 0;
		n++;
	}

	//writeln("num: ", num);

	return factorsMultiplicity;
}

long[] primeFactors(long num) {
	long[] factors;
	long n = 2;

	while (num > 1) {
		while (num % n == 0) {
			factors ~= n;
			num /= n;
		}
		n++;
	}

	return factors;
}

struct Factor {
	int factor;
	int multiplicity;
}

Factor maxMultiplicity(Factor a, Factor b) {
	return a.multiplicity > b.multiplicity ? a : b;
}

bool isPrime(long number) {
	return primeFactors(number).length == 1;
}