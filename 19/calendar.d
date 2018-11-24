module calendar;

class Calendar {
private:
  int dayInWeek;
  int day;
  int month;
  int year;
  string[] weekDayWords;
  string[] monthWords;
  bool isLeapYear;
  int daysInThisMonth;

  int calcDaysInMonth() {
    switch (month) {
      case 4:
      case 6:
      case 9:
      case 11:  daysInThisMonth = 30;
        break;
      case 28:  daysInThisMonth = isLeapYear ? 29 : 28;
        break;
      default:  daysInThisMonth = 31;
    }
    return daysInThisMonth;
  }

  bool calcIsLeapYear() {
    if (year % 100 == 0)
      if (year % 400 == 0)
        isLeapYear = true;
      else
        isLeapYear = false;
    else if (year % 4 == 0)
      isLeapYear = true;
    else
      isLeapYear = false;

    return isLeapYear;
  }

public:
  this() {
    weekDayWords = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    monthWords = ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];
    day = 1;
    month = 1;
    year = 1900;
    dayInWeek = 2;
    calcDaysInMonth();
    calcIsLeapYear();
  }

  int getDay() {
    return day;
  }
  int getMonth() {
    return month;
  }
  string getMonthWord() {
    return monthWords[month - 1];
  }
  int getYear() {
    return year;
  }
  int getWeekDay() {
    return dayInWeek;
  }
  string getWeekDayWord() {
    return weekDayWords[dayInWeek - 1];
  }
  int getDaysInMonth() {
    return daysInThisMonth;
  }
  void nextDay() {
    day++;

    if (day > daysInThisMonth) {
      day = 1;
      month++;
      if (month > 12) {
        month = 1;
        year++;
        calcIsLeapYear();
      }
      calcDaysInMonth();
    }

    dayInWeek++;
    if (dayInWeek > 7)
      dayInWeek = 1;
  }
  void prevDay() {
    day--;

    if (day < 1) {
      month--;
      if (month < 1) {
        month = 12;
        year--;
        calcIsLeapYear();
      }
      calcDaysInMonth();
      day = daysInThisMonth;
    }
  }
}
