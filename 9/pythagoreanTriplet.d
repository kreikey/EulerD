class PythagoreanTriplet {
private:
  int i;
  int j;
  int k;
  bool _isFinished;
  bool _tripletFound;
  PerfectSquares pSquares;

public:
  this(int n) {
    pSquares = new PerfectSquares(n);
    i = 0;
    j = 1;
    k = 2;
    _isFinished = false;
    _tripletFound = false;
    nextTriplet();
  }

  int getA() {
    return pSquares.values[i];
  }

  int getB() {
    return pSquares.values[j];
  }

  int getC() {
    return pSquares.values[k];
  }

  int getASquared() {
    return pSquares.squares[i];
  }

  int getBSquared() {
    return pSquares.squares[j];
  }

  int getCSquared() {
    return pSquares.squares[k];
  }

  bool nextCandidate() {
    _isFinished = false;

    if (k < (pSquares.size - 1)) {
      k++;
      _isFinished = false;
    } else if (j < (pSquares.size - 2)) {
      j++;
      k = j + 1;
      _isFinished = false;
    } else if (i < (pSquares.size - 3)) {
      i++;
      j = i + 1;
      k = j + 1;
      _isFinished = false;
    } else {
      i = 0;
      j = 1;
      k = 2;
      _isFinished = true;
    }

    return _isFinished;
  }

  bool isFinished() {
    return _isFinished;
  }

  bool isTriplet() {
    bool isTriplet;

    if (getASquared() + getBSquared() == getCSquared())
      isTriplet = true;
    else
      isTriplet = false;

    return isTriplet;
  }

  bool nextTriplet() {
    do {
      nextCandidate();
    } while (!isTriplet() && !isFinished());

    if (isTriplet())
      _tripletFound = true;
    if (isFinished() == true)
      _tripletFound = false;

    return _tripletFound;
  }

  bool tripletFound() {
    return _tripletFound;
  }

private:
  class PerfectSquares {
    int size;
    int[] values;
    int[] squares;

    this(int n) {
      size = n;
      values.length = size;
      squares.length = size;

      foreach (int i; 0 .. n) {
        values[i] = i + 1;
        squares[i] = values[i] * values[i];
      }
    }
  }
}
