module productIter;

class ProductIter {

private:
  int product;
  int head;
  int tail;
  int length;
  string digits;

public:
  this(string digs, int segSize) {
    digits = digs;
    length = cast(int)digits.length;
    head = segSize;
    tail = 0;

    if (!isFinished()) {
      product = cast(int)(digits[tail] - 48);
      tail++;

      foreach (int i; tail .. head){
        product *= cast(int)(digits[i] - 48);
      }
    }

    head++;
  }

  int getProduct() {
    return product;
  }

  int nextProduct() {
    if (isFinished())
      return 0;

    product = cast(int)(digits[tail] - 48);
    tail++;

    foreach (int i; tail .. head){
      product *= cast(int)(digits[i] - 48);
    }

    head++;

    return product;
  }

  bool isFinished() {
    if (head >= length)
      return true;
    else
      return false;
  }
}

