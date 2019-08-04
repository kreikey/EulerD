#!/usr/bin/env rdmd -I..

import std.stdio;
import std.datetime.stopwatch;
import std.conv;
import std.array;
import std.algorithm;
import calendar;

void main() {
  StopWatch sw;
  Calendar cal = new Calendar();
  int sundayTheFirstCount;
  int startDay, startMonth, startYear, endDay, endMonth, endYear;
  string startMonthWord, endMonthWord;

  sw.start();

  while (cal.getYear() < 1901)
    cal.nextDay();

  startDay = cal.getDay();
  startMonthWord = cal.getMonthWord();
  startYear = cal.getYear();

  do {
    if (cal.getDay() == 1 && cal.getWeekDayWord() == "Sunday")
      sundayTheFirstCount++;
    cal.nextDay();
  } while (cal.getYear() < 2001);
  cal.prevDay();

  sw.stop();
  writefln("there are %s Sundays on the first of the month \nbetween %s %s %s and %s %s %s",
    sundayTheFirstCount, startDay, startMonthWord, startYear,
    cal.getDay(), cal.getMonthWord(), cal.getYear());
  writefln("finished in %s milliseconds", sw.peek.total!"msecs"());
}
