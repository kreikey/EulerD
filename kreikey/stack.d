module kreikey.stack;

import std.stdio;
import core.exception;

struct Stack(T) {
  T[] items;

  bool empty() @property {
    return (items.length == 0);
  }

  T peek() @property {
    T item;

    try {
      item = items[$-1];
    } catch (RangeError r) {
      writeln(r.msg, ":");
      writeln("Can't peek at empty stack");
    }

    return item;
  }

  void push(T item) {
    items ~= item;
  }

  T pop() {
    T item;

    try {
      item = items[$-1];
      items.length -= 1;
    } catch (RangeError r) {
      writeln(r.msg, ":");
      writeln("Can't pop an empty stack");
    }

    return item;
  }
}
