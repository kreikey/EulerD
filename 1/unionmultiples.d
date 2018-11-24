module unionmultiples;
//import std.stdio;

final class UnionMultiples {
private:
  ulong a;
  ulong b;
  ulong _front;

public:
  // ------- Constructor -------
  this(ulong a, ulong b) {
    this.a = a;
    this.b = b;
    popFront();
  }

  // ------- Range Primitives -------
  enum bool empty = false;

  ulong front() @property const nothrow pure {
    return _front;
  }

  void popFront() @safe nothrow pure {
    do {
      _front++;
    } while (_front % a != 0 && _front % b != 0);
  }

  typeof(this) save() @property {
    auto ret = new typeof(this)(this.a, this.b);
    ret._front = this._front;
    return ret;
  }

  ulong opIndex(int i) {
    ulong ret;

    reset();

    foreach (x; 0 .. i)
      popFront();

    ret = _front;

    reset();
    return ret;
  }

  // ------- Other useful methods -------
  void reset() {
    this._front = 0;
    popFront();
  }
}
