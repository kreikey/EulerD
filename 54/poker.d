module poker;

import std.algorithm;
import std.range;
import std.regex;
import std.stdio;

struct Card {
  int value;
  char suit;

  this(string source) {
    value = source[0] >= '2' && source[0] <= '9' ? source[0] - '0' :
      source[0] == 'T' ? 10 :
      source[0] == 'J' ? 11 :
      source[0] == 'Q' ? 12 :
      source[0] == 'K' ? 13 :
      source[0] == 'A' ? 14 : 0;
    assert (value != 0);
    suit = source[1] == 'S' ? 'S' :
      source[1] == 'C' ? 'C' :
      source[1] == 'D' ? 'D' :
      source[1] == 'H' ? 'H' : '0';
    assert (suit != '0');
  }

  int opCmp(typeof(this) rhs) {
    if (this.value < rhs.value)
      return -1;
    else if (this.value > rhs.value)
      return 1;
    else
      return 0;
  }
}

struct Hand {
  Card[] cards;
  int rank;

  this(Card[] source) {
    assert(source.length == 5);
    this.cards = source;
    sort!((a, b) => a > b)(cards);
    this.rank = getRank();
  }

  int opCmp(typeof(this) rhs) {
    if (this.rank < rhs.rank)
      return -1;
    else if (this.rank < rhs.rank)
      return 1;
    else {
      auto leftGroup = this.cards
        .group!((a, b) => a.value == b.value)
        .array();
      auto rightGroup = rhs.cards
        .group!((a, b) => a.value == b.value)
        .array();
      leftGroup.sort!((a, b) => a[1] > b[1], SwapStrategy.stable)();
      rightGroup.sort!((a, b) => a[1] > b[1], SwapStrategy.stable)();

      foreach (lg, rg; lockstep(leftGroup, rightGroup)) {
        if (lg[0] < rg[0])
          return -1;
        else if (lg[0] > rg[0])
          return 1;
      }

      return 0;
    }
  }

  int getRank() {
    int result;

    if (isRoyalFlush()) {
      result = 10;
    } else if (isStraightFlush()) {
      result = 9;
    } else if (isFourOfAKind()) {
      result = 8;
    } else if (isFullHouse()) {
      result = 7;
    } else if (isFlush()) {
      result = 6;
    } else if (isStraight()) {
      result = 5;
    } else if (isThreeOfAKind()) {
      result = 4;
    } else if (isTwoPair()) {
      result = 3;
    } else if (isOnePair()) {
      result = 2;
    } else {
      result = 1;
    }

    return result;
  }

  bool isRoyalFlush() {
    return cards[0].value == 14 && isStraightFlush();
  }

  bool isStraightFlush() {
    return isFlush() && isStraight();
  }

  bool isFourOfAKind() {
    return cards
      .group!((a, b) => a.value == b.value)
      .canFind!(a => a[1] == 4)();
  }

  bool isFullHouse() {
    auto groups = cards
      .group!((a, b) => a.value == b.value);

    return groups.canFind!(a => a[1] == 3)() && groups.canFind!(a => a[1] == 2)();
  }

  bool isFlush() {
    foreach (p; cards.slide(2)) {
      if (p[0].suit != p[1].suit)
        return false;
    }
    
    return true;
  }

  bool isStraight() {
    foreach (p; cards.slide(2)) {
      if (p[0].value != p[1].value + 1)
        return false;
    }

    return true;
  }

  bool isThreeOfAKind() {
    return cards
      .group!((a, b) => a.value == b.value)
      .canFind!(a => a[1] == 3);
  }

  bool isTwoPair() {
    auto pairCount = cards
      .group!((a, b) => a.value == b.value)
      .count!(a => a[1] == 2)();

    return pairCount == 2;
  }

  bool isOnePair() {
    return cards
      .group!((a, b) => a.value == b.value)
      .canFind!(a => a[1] == 2)();
  }
}
