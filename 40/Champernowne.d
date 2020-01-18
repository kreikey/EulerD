module champernowne;
import kreikey.intmath;
import kreikey.bytemath;

struct Champernowne {
  private:
    uint[] digits = [1];
    ulong topNum = 1;
    size_t fidx = 0;

  public:
    enum bool empty = false;

    uint front() @property {
      return digits[fidx];
    }

    void popFront() {
      fidx++;
      if (fidx > digits.length - 1) {
        topNum++;
        digits ~= topNum.toDigits();
      }
    }

    typeof(this) save() @property {
      typeof(this) copy;

      copy.digits = this.digits.dup;
      copy.topNum = this.topNum;
      copy.fidx = this.fidx;

      return copy;
    }

    uint opIndex(size_t idx) {
      while ((idx - 1) >= digits.length)
        this.popFront;
      return digits[idx - 1];
    }
}

