enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

const numOfDaysInWeek = 7;

class DateUtils {
  /// Get all the dates in a month
  static Iterable<DateTime> getDaysInMonth(DateTime month) {
    final first = firstDayOfMonth(month);
    final last = lastDayOfMonth(month);

    return getDatesInRange(first, last);
  }

  /// Get the first date of the month
  static DateTime firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month, 1, 12);
  }

  /// Get the last date of the month
  static DateTime lastDayOfMonth(DateTime month) {
    final date = DateTime.utc(month.year, month.month + 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  /// Check if the two date objects are the same day
  ///
  /// Return [true] if two dates are the same, else [false]
  static bool isSameDay(DateTime dayA, DateTime dayB) {
    return dayA.year == dayB.year &&
        dayA.month == dayB.month &&
        dayA.day == dayB.day;
  }

  /// Get the number of day before a weekday
  ///
  /// Tuesday has one day before it: Monday
  /// Wednesday has two days before it: Monday and Tuesday
  static int getNumOfWeekDaysBefore(DateTime firstDay) {
    return firstDay.weekday - getWeekdayNumber(StartingDayOfWeek.monday);
  }

  /// Get a weekday number from [StartingDayOfWeek] object
  ///
  /// This is equivalent to [DateTime.now().weekday]
  static int getWeekdayNumber(StartingDayOfWeek weekday) {
    return StartingDayOfWeek.values.indexOf(weekday) + 1;
  }

  static Iterable<DateTime> getDatesInRange(
      DateTime firstDate, DateTime lastDate) sync* {
    if (isSameDay(firstDate, lastDate)) {
      yield _normalizedDate(firstDate);
    }
    var temp = firstDate;

    while (temp.isBefore(lastDate)) {
      yield _normalizedDate(temp);
      temp = temp.add(const Duration(days: 1));
    }
    yield _normalizedDate(lastDate);
  }

  static int getDaysAfter(DateTime lastDay) {
    int invertedStartingWeekday =
        8 - getWeekdayNumber(StartingDayOfWeek.monday);

    int daysAfter = 7 - ((lastDay.weekday + invertedStartingWeekday) % 7) + 1;
    if (daysAfter == 8) {
      daysAfter = 1;
    }

    return daysAfter;
  }

  static bool isDatesConsecutive(dates) {
    if (dates.length == 1) {
      return false;
    }

    for (int i = 0; i < dates.length - 1; i++) {
      final dateA = dates[i];
      final dateB = dates[i + 1];
      // check the difference between two dates
      if ((dateA.day - dateB.day).abs() != 1) {
        return false;
      }
    }

    return true;
  }

  static bool isBetweenTwoDates(date, startDate, endDate) {
    if (isSameDay(date, startDate) || isSameDay(date, endDate)) return true;
    if (date.isAfter(startDate) && date.isBefore(endDate)) return true;
    return false;
  }

  static bool isWeekend(DateTime date) {
    const saturday = 6;
    const sunday = 7;
    return date.weekday == saturday || date.weekday == sunday;
  }

  static DateTime firstDayOfWeek(DateTime day) {
    day = _normalizedDate(day);

    final decreaseNum = getNumOfWeekDaysBefore(day);
    return day.subtract(Duration(days: decreaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    day = _normalizedDate(day);

    final increaseNum = getNumOfWeekDaysBefore(day);
    return day.add(Duration(days: 7 - increaseNum)).subtract(Duration(days: 1));
  }

  static bool isInRange(DateTime date, List<DateTime> dates) {
    for (int i = 0; i < dates.length; i++) {
      if (isSameDay(date, dates[i])) {
        return true;
      }
    }
    return false;
  }

  /// check if the date is in the current billing period
  /// this is assumed that the start and end of the billing period would be
  /// the start and end of the month respectively
  static bool isCurrentBillingPeriod(DateTime date) {
    final now = DateTime.now();

    final lastDayOfLastBillingPeriod = DateTime(now.year, now.month, 1 - 1);
    final startOfTheMonth = DateTime(date.year, date.month, 1);

    if (startOfTheMonth.isBefore(lastDayOfLastBillingPeriod) ||
        isSameDay(startOfTheMonth, lastDayOfLastBillingPeriod)) {
      return false;
    }

    return true;
  }

  /// Convert the first date to the begining of that date
  /// and last date to the midnight of that date
  ///
  /// Ex: first date is 12/12/2019 will be 12/12/2019.000000
  /// last date is 13/12/2019 will be 13/12/2019.9999999
  static List<DateTime> getFirstAndLastTimeOfDateRange(
      DateTime firstDate, DateTime lastDate) {
    firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    lastDate = DateTime.fromMillisecondsSinceEpoch(
        (DateTime(lastDate.year, lastDate.month, lastDate.day + 1)
                .millisecondsSinceEpoch) -
            1);

    return [firstDate, lastDate];
  }

  /// Get the display format of an hour
  ///
  /// Ex: 8.00 will become 08:00
  static String getDisplayHours(double hours) {
    String displayHours = hours.toInt().toString();
    String displayMinutes = ((hours * 60) % 60).toInt().toString();

    if (displayHours.length == 1) {
      displayHours = '0' + displayHours;
    }
    if (displayMinutes.length == 1) {
      displayMinutes = '0' + displayMinutes;
    }

    return "$displayHours:$displayMinutes";
  }

  /// Get the display format of a date from a datetime object
  ///
  /// Ex: DateTime(2014, 12, 12) => 12/12/2014
  /// Datetime of today will be "Today"
  static String getDisplayDate(DateTime date) {
    String displayedDate = "";

    final DateTime now = DateTime.now();

    if (DateUtils.isSameDay(date, now)) {
      // if the date is today then display "Today"
      displayedDate = "Today";
    } else {
      String displayMonth = date.month.toString().length == 1
          ? "0" + date.month.toString()
          : date.month.toString();
      String displayDay = date.day.toString().length == 1
          ? "0" + date.day.toString()
          : date.day.toString();
      displayedDate = '$displayDay/$displayMonth/${date.year}';
    }
    return displayedDate;
  }

  static List<DateTime> daysInWeek(DateTime week) {
    final first = DateUtils.firstDayOfWeek(week);
    final last = DateUtils.lastDayOfWeek(week);
    return getDatesInRange(first, last).toList();
  }

  static DateTime _normalizedDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day);
  }
}
