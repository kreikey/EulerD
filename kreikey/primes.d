module kreikey.primes;
import std.traits;

final class Primes(T)
if (isIntegral!T) {
private:
	T num;
	T ndx;
	T root;
	T nextSquare;
	T[] primes;

	bool isPrime() {
		if (num < 2)
			return false;
		foreach (i; 0 .. primes.length) {
			if (primes[i] > root) {
				break;
			}
			if (num % primes[i] == 0) {
				return false;
			}
		}
		return true;
	}

public:
	// ------- Constructors -------
	this() {
		primes.reserve(1000);
		num = 1;
		root = 1;
		nextSquare = (root + 1) ^^ 2;
		ndx = 0;
		popFront();
	}

	this(int initialCapacity) {
		primes.reserve(initialCapacity);
		num = 1;
		root = 1;
		nextSquare = (root + 1) ^^ 2;
		ndx = 0;
		popFront();
	}

	// ------- Range Primitives -------
	enum bool empty = false;

	void popFront() {
		if (ndx < primes.length) {
			num = primes[ndx++];
			return;
		}
		do {
			num++;
			if (num >= nextSquare) {
				root++;
				nextSquare = (root + 1) ^^ 2;
			}
		} while (!isPrime());
		if (primes.length == primes.capacity)
			primes.reserve(primes.capacity * 2);
		primes ~= num;
		ndx++;
	}

	T front() @property {
		return num;
	}

	typeof(this) save() @property {
		auto ret = new typeof(this)();
		ret.num = this.num;
		ret.ndx = this.ndx;
		ret.root = this.root;
		ret.nextSquare = this.nextSquare;
		ret.primes = this.primes.dup;
		return ret;
	}

	T opIndex(uint i) {
		T ret;

		if (i < primes.length) {
			ndx = i;
			popFront();
			ret = num;
		} else {
			num = primes[$ - 1];
			ndx = cast(T)primes.length;
			do {
				popFront();
			} while (ndx <= i);
			ret = num;
		}

		reset();
		return ret;
	}

	// ------- Other useful methods -------
	void reset() {
		num = 1;
		ndx = 0;
		popFront();
	}
}
