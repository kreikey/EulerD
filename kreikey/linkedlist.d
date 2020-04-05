module kreikey.linkedlist;

import std.conv : to;
import std.range;
import std.stdio;

struct LinkedList(T) {
  Node!T* first = null;
  Node!T* last = null;
  Node!T* cur = null;

  this(R)(R items)
  if (isInputRange!R) {
    foreach (item; items) {
      append(item);
    }
    cur = first;
  }

  void insert(Node!T* item, Node!T* existing) {
    if (existing == null) {
      item.next = first;
      item.prev = null;
      if (first)
        first.prev = item;
      first = item;
      if (!item.next)
        last = item;
    } else {
      item.next = existing.next;
      item.prev = existing;
      existing.next = item;

      if (existing == last) {
        last = item;
      } else {
        item.next.prev = item;
      }
    }
  }

  void insertBefore(T value) {
    auto item = new Node!T(value);

    if (cur != null)
      cur = cur.prev;

    insert(item, cur);
    cur = item;
  }

  void insertAfter(T value) {
    auto item = new Node!T(value);

    insert(item, cur);
    cur = item;
  }

  void append(T value) {
    auto item = new Node!T(value);
    
    insert(item, last);
    last = item;
  }

  void prepend(T value) {
    auto item = new Node!T(value);

    insert(item, null);
    first = item;
  }

  // existing is never null
  Node!T* remove(Node!T* existing) {
    if (existing == first) {
      first = first.next;
      if (first)
        first.prev = null;
    } else {
      existing.prev.next = existing.next;
    }
    if (existing == last) {
      last = last.prev;
      if (last)
        last.next = null;
    } else {
      existing.next.prev = existing.prev;
    }
    
    existing.next = null;
    existing.prev = null;

    return existing;
  }

  T removePrev() {
    Node!T* result = null;
    Node!T* temp = null;

    if (cur == null)
      throw new Exception("Cannot remove from an empty list.");

    if (cur != first)
      temp = cur.prev;
    else
      temp = cur.next;

    result = remove(cur);
    cur = temp;

    return result.item;
  }

  T removeNext() {
    Node!T* result = null;
    Node!T* temp = null;

    if (cur == null)
      throw new Exception("Cannot remove from an empty list.");

    if (cur.next != null)
      temp = cur.next;
    else
      temp = cur.prev;

    result = remove(cur);
    cur = temp;

    return result.item;
  }
}

struct Node(T) {
  Node!T* next = null;
  Node!T* prev = null;
  T item;

  this(T _item) {
    item = _item;
  }

  string toString() {
    return item.to!string();
  }
}
