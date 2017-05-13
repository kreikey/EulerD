module kreikey.fibonacci;

final class Fibonacci {
private:
	ulong a;
	ulong b;
	ulong _front;
public:
	this() {
		this.b = 1;
		popFront();
	}

	enum bool empty = false;

	ulong front() @property const nothrow pure {
		return _front;
	}

	void popFront() @safe nothrow pure {
		_front = b + a;
		a = b;
		b = _front;
	}

	typeof(this) save() @property {
		auto ret = new typeof(this)();
		ret._front = this._front;
		return ret;
	}

	void reset() {
		this._front = 0;
		this.a = 0;
		this.b = 1;
		popFront();
	}

}