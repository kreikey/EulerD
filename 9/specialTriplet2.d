#!/usr/bin/env rdmd -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;

void main() {
  ulong b;
  ulong c;
  ulong p;
  ulong asq;
  ulong bsq;
  ulong csq;
  double bdec;
  ulong ratiorem;
  double ratio;
  ulong bsource;
  double bdecsq;
  ulong brem;
  ulong numerator;
  ulong denominator;
  StopWatch timer;

  // implemented a more efficient, more specialized algorithm here.
  /*
     I found this algorithm in the forums. It works for a perimeter of 1,000, but not for any perimeter. I'm not sure how it works, 
     but I have some idea. It takes from B which starts at half the perimeter and puts it into A, which starts at 0. That means the 
     perimeter doesn't stay at 1,000. But it's not the real B, it's a scaled down version. So you adjust B to the ratio of 
     (perimeter / (perimeter - A)) which somehow is the right ratio to scale B to the right size to where the perimeter will be 
     1,000. Of course that makes sense because I define C as 1,000 - A - B. I'm not sure why it's the right ratio. But what is the 
     right ratio? If I'm defining C in terms of perimeter, A, and B, then why does it matter? I guess it still has to satisfy the 
     pythagorean theorem. Does it always satisfy the pythagorean theorem? No. But it does when the scaled version of B evaluates 
     to an integer without a remainder. Why is that?
 */

  timer.start();
  for (ulong a = 1; a < 500; a++) {
    b = 1000 * (500 - a) / (1000 - a);  // b / (b + c)
    bdec = float(1000) * (500 - a) / (1000 - a);
    ratiorem = 1000 % (1000 - a);
    ratio = float(1000) / (1000 - a);
    bsource = 500 - a;
    c = 1000 - a - b;
    p = a + b + c;
    asq = a ^^ 2;
    bsq = b ^^ 2;
    csq = c ^^ 2;
    bdecsq = bdec ^^ 2;
    brem = 1000 * (500 - a) % (1000 - a);
    numerator = 1000 * (500 - a);
    denominator = 1000 - a;

    //writefln("%s %s %s %s %s", a, b, 500 - a, c, p);
    writefln("bsource: %s, numerator: %s, denominator: %s, brem: %s, bdec: %s", bsource, numerator, denominator, brem, bdec);
    writefln("%s^2 + %s^2 = %s^2? %s = %s? %s", a, b, c, asq + bsq, csq, asq + bsq == csq);
    writefln("%s^2 + %s^2 = %s^2? %s = %s?", a, bdec, c, asq + bdecsq, csq);

    if (1000 * (500 - a) % (1000 - a) == 0) {
      writefln("%s^2 + %s^2 = %s^2", a, b, c);
      writefln("%s + %s = %s", a*a, b*b, c*c);
      writefln("%s + %s + %s = %s", a, b, c, a + b + c);
      writefln("%s * %s * %s = %s", a, b, c, a * b * c);
    }
  }
  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
