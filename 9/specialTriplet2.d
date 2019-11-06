#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.conv;
import std.math;
import std.datetime.stopwatch;

void main(string[] args) {
  ulong a;
  ulong b;
  ulong c;
  ulong p = 1000;
  ulong divisor;
  ulong dividend;
  bool tripletFound = false;

  if (args.length > 1) {
    p = parse!ulong(args[1]);
  }

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
     OK, I get it now. You derive the formula from the system of equations: 
     a^2 + b^2 = c^2
     a + b + c = p
     Eliminate C and solve for B in terms of A. The result is:
     b = p (p/2 - a) / (p - a)
     This can be thought of as a ratio that can be applied to the perimeter to get B. The bounds of B range from 0 to P/2.
     These bounds are inversely related to A in that, the greater A is the less B is, and the less A is the greater B is.
     Whatever the ratio turns out to be, it must be constructed in a way that when A is 0, B is P/2, and when A is P/2 (its max),
     B is 0, all when the ratio is multiplied by P. (p/2 - a) / (p - a) fits the bill. Working out the math to derive the formula:
     a^2 + b^2 = c^2
     (p - a - b)^2 = c^2
     a^2 + b^2 = p^2 - ap - bp - ap + a^2 + ab - bp + ab + b^2
     a^2 + b^2 - p^2 + 2ap - a^2 - b^2 = 2ab - 2bp
     2ap - p^2 = b(2a - 2p)
     b = (2ap - p^2) / (2a - 2p) = p (2a - p) / (2a - 2p) = p (2) (a - p/2) / ((2) (a - p)) = p (a - p/2) / (a - p)
     b = p (-1) (p/2 - a) / ((-1) (p - a)) = p (p/2 - a) / (p - a)
 */

  timer.start();
  writeln("special pythagorean triplet");

  if (p % 2 != 0) {
    writeln("The perimeter must be even!");
    return;
  }

  for (a = 1; a < p/2; a++) {
    divisor = p * (p / 2 - a);
    dividend = (p - a);
    if (divisor % dividend == 0) {
      b = divisor / dividend;
      c = p - a - b;
      tripletFound = true;
      break;
    }
  }

  if (tripletFound) {
    writefln("%s^2 + %s^2 = %s^2", a, b, c);
    writefln("%s * %s * %s = %s", a, b, c, a * b * c);
  } else {
    writeln("no pythagorean triplet found");
  }

  timer.stop();
  writefln("finished in %s milliseconds.", timer.peek().total!"msecs");
}
