module kreikey.linkedlist;

import std.conv : to;
import std.range;
import std.stdio;
import std.traits;
import core.exception;

auto toLinkedList(R)(R items)
if (isInputRange!R) {
  return LinkedList!(ElementType!R)(items);
}

template LinkedList(T) {
  struct LinkedList {
    Node* first = null;
    Node* last = null;
    Node* cur = null;
    ulong length = 0;

    this(R)(R items)
    if (isInputRange!R && is(ElementType!R == T)) {
      foreach (item; items) {
        append(item);
      }

      cur = first;
    }

    private void insert(Node* item, Node* existing) {
      item.prev = existing;
      item.next = existing ? existing.next : first;
      if (item.next)
        item.next.prev = item;
      if (item.prev)
        item.prev.next = item;
      if (item.next == first)
        first = item;
      if (item.prev == last)
        last = item;

      length++;
    }

    void append(T value) {
      auto item = new Node(value);
      
      insert(item, last);
      last = item;
      cur = item;
    }

    void prepend(T value) {
      auto item = new Node(value);

      insert(item, null);
      first = item;
      cur = item;
    }

    // existing is never null
    private Node* remove(Node* existing) {
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
      
      length--;

      return existing;
    }

    void insertBefore(T value) {
      auto item = new Node(value);

      if (cur != null)
        cur = cur.prev;

      insert(item, cur);
      cur = item;
    }

    void insertAfter(T value) {
      auto item = new Node(value);

      insert(item, cur);
      cur = item;
    }

    T removeCur() {
      Node* result = null;
      Node* temp = null;

      if (cur == null)
        throw new Exception("Cannot remove from an empty list.");

      if (cur != first)
        temp = cur.prev;
      else
        temp = cur.next;

      result = remove(cur);
      cur = temp;

      return result.payload;
    }

    //T removeNext() {
      //Node* result = null;
      //Node* temp = null;

      //if (cur == null)
        //throw new Exception("Cannot remove from an empty list.");

      //if (cur.next != null)
        //temp = cur.next;
      //else
        //temp = cur.prev;

      //result = remove(cur);
      //cur = temp;

      //return result.payload;
    //}

    T getFirst() {
      cur = first;

      if (cur == null)
        throw new Exception("Attempting to getFirst() in LinkedList of type " ~ T.stringof ~ " with null first node");

      return cur.payload;
    }

    T getLast() {
      cur = last;

      if (cur == null)
        throw new Exception("Attempting to getLast() in LinkedList of type " ~ T.stringof ~ " with null last node");

      return cur.payload;
    }

    T getCur() {
      if (cur == null)
        throw new Exception("Attempting to getCur() in a LinkedList of type " ~ T.stringof ~ " with null cur node");

      return cur.payload;
    }

    auto byItem() @property {
      return ByItemResult(&this);
    }

    auto byNode() @property {
      return ByNodeResult(&this);
    }

    auto opSlice() {
      return ByItemResult(&this);
    }

    bool empty() @property {
      return length == 0;
    }
  }

  private struct Node {
    Node* next = null;
    Node* prev = null;
    T payload;

    this(T _payload) {
      payload = _payload;
    }

    string toString() {
      return payload.to!string();
    }
  }

  private struct ByItemResult {
    LinkedList* myList;
    Node* frontNode;
    Node* backNode;
    bool _empty;

    this(LinkedList* _myList) {
      frontNode = _myList.first;
      backNode = _myList.last;
      _empty = frontNode == null && backNode == null;
      myList = _myList;
      myList.cur = frontNode;
    }

    T front() @property {
      if (_empty)
        throw new Exception("Attempting to fetch the front of an empty LinkedList range of " ~ T.stringof);

      return frontNode.payload;
    }

    void popFront() {
      if (_empty)
        return;

      if (frontNode == backNode)
        _empty = true;

      frontNode = frontNode.next;

      if (frontNode)
        myList.cur = frontNode;
    }

    T back() @property {
      if (_empty)
        throw new Exception("Attempting to fetch the back of an empty LinkedList range of " ~ T.stringof);

      return backNode.payload;
    }

    void popBack() {
      if (_empty)
        return;

      if (frontNode == backNode)
        _empty = true;

      backNode = backNode.prev;

      if (backNode)
        myList.cur = backNode;
    }

    bool empty() @property {
      return _empty;
    }

    auto save() @property {
      auto copy = this;
      return copy;
    }

    //T removeFront() {
      //if (_empty)
        //throw new Exception("Attempting to removeFront() from an empty LinkedList range of " ~ T.stringof);

      //Node* myNode = myList.remove(frontNode);

      //return myNode.payload;
    //}

    //T removeBack() {
      //if (_empty)
        //throw new Exception("Cannot removeBack() from an empty LinkedList range of " ~ T.stringof);

      //Node* myNode = myList.remove(backNode);

      //return myNode.payload;
    //}

    //void insertFront(T value) {
      //Node* item = new Node(value);
      //Node* temp = frontNode.prev;
      //myList.insert(item, temp);
      //frontNode = item;
    //}

    //void insertBack(T value) {
      //Node* item = new Node(value);
      //myList.insert(item, backNode);
      //backNode = item;
    //}
  }

  private struct ByNodeResult {
    LinkedList* myList;
    Node* frontNode;
    Node* backNode;
    bool _empty;

    this(LinkedList* _myList) {
      frontNode = _myList.first;
      backNode = _myList.last;
      _empty = frontNode == null && backNode == null;
      myList = _myList;
      myList.cur = frontNode;
    }

    Node* front() @property {
      if (_empty)
        throw new Exception("Attempting to fetch the front of an empty LinkedList range of " ~ T.stringof);

      return frontNode;
    }

    void popFront() {
      if (_empty)
        return;

      if (frontNode == backNode)
        _empty = true;

      frontNode = frontNode.next;

      if (frontNode)
        myList.cur = frontNode;
    }

    Node* back() @property {
      if (_empty)
        throw new Exception("Attempting to fetch the back of an empty LinkedList range of " ~ T.stringof);

      return backNode;
    }

    void popBack() {
      if (_empty)
        return;

      if (frontNode == backNode)
        _empty = true;

      backNode = backNode.prev;

      if (backNode)
        myList.cur = backNode;
    }

    bool empty() @property {
      return _empty;
    }

    auto save() @property {
      auto copy = this;
      return copy;
    }

    //T removeFront() {
      //if (_empty)
        //throw new Exception("Attempting to removeFront() from an empty LinkedList range of " ~ T.stringof);

      //Node* myNode = myList.remove(frontNode);

      //return myNode.payload;
    //}

    //T removeBack() {
      //if (_empty)
        //throw new Exception("Cannot removeBack() from an empty LinkedList range of " ~ T.stringof);

      //Node* myNode = myList.remove(backNode);

      //return myNode.payload;
    //}

    //void insertFront(T value) {
      //Node* item = new Node(value);
      //Node* temp = frontNode.prev;
      //myList.insert(item, temp);
      //frontNode = item;
    //}

    //void insertBack(T value) {
      //Node* item = new Node(value);
      //myList.insert(item, backNode);
      //backNode = item;
    //}
  }
}

void printList(T)(T list)
if (isInstanceOf!(LinkedList, T)) {
  auto cur = list.first;
  write("[");
  while (cur != null) {
    write(*cur);
    if (cur != list.last)
      write(", ");
    cur = cur.next;
  }
  writeln("]");
}

