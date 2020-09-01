import 'package:flutter_test/flutter_test.dart';
import 'package:lod_flutter/src/utils/date_utils.dart';

void main() {
  group('getDaysInMonth tests', () {
    test('return all the dates for August 2020', () {
      var date = DateTime(2020, 08, 14, 0, 0, 0);
      var daysInMonth = DateUtils.getDaysInMonth(date).toList();

      const numOfDaysInAugust = 31;
      expect(daysInMonth.length, numOfDaysInAugust);

      for (int i = 0; i < numOfDaysInAugust; i++) {
        expect(daysInMonth[i].year, date.year);
        expect(daysInMonth[i].month, date.month);
        expect(daysInMonth[i].day, i + 1);
      }

      // again but the input is the very last second of the day
      date = DateTime(2020, 08, 14, 23, 59, 59);
      daysInMonth = DateUtils.getDaysInMonth(date).toList();

      expect(daysInMonth.length, numOfDaysInAugust);

      for (int i = 0; i < numOfDaysInAugust; i++) {
        expect(daysInMonth[i].year, date.year);
        expect(daysInMonth[i].month, date.month);
        expect(daysInMonth[i].day, i + 1);
      }
    });

    test('return all the dates in Feburary 2020 (leap year)', () {
      final date = DateTime(2020, 02, 10);
      final daysInMonth = DateUtils.getDaysInMonth(date).toList();

      const numOfDaysInFebruary = 29;
      expect(daysInMonth.length, numOfDaysInFebruary);

      for (int i = 0; i < numOfDaysInFebruary; i++) {
        expect(daysInMonth[i].year, date.year);
        expect(daysInMonth[i].month, date.month);
        expect(daysInMonth[i].day, i + 1);
      }
    });

    test('return all the dates in Feburary 2019 (non-leap year)', () {
      final date = DateTime(2019, 02, 10);
      final daysInMonth = DateUtils.getDaysInMonth(date).toList();

      const numOfDaysInFebruary = 28;
      expect(daysInMonth.length, numOfDaysInFebruary);

      for (int i = 0; i < numOfDaysInFebruary; i++) {
        expect(daysInMonth[i].year, date.year);
        expect(daysInMonth[i].month, date.month);
        expect(daysInMonth[i].day, i + 1);
      }
    });
  });

  group('firstDayOfMonth tests', () {
    test('return an utc date day of month in August 2020', () {
      final date = DateTime(2020, 8, 12);
      final firstDayOfMonth = DateUtils.firstDayOfMonth(date);

      final expected = DateTime.utc(2020, 8, 1);
      expect(firstDayOfMonth.day, expected.day);
      expect(firstDayOfMonth.month, expected.month);
      expect(firstDayOfMonth.year, expected.year);
    });

    test('return an utc date day of month in Feburary 2020', () {
      final date = DateTime(2020, 2, 29);
      final firstDayOfMonth = DateUtils.firstDayOfMonth(date);

      final expected = DateTime.utc(2020, 2, 1);
      expect(firstDayOfMonth.day, expected.day);
      expect(firstDayOfMonth.month, expected.month);
      expect(firstDayOfMonth.year, expected.year);
    });
  });

  group('lastDayOfMonth tests', () {
    test('return an utc date day of month in December 2020', () {
      final date = DateTime(2020, 12, 4);
      final firstDayOfMonth = DateUtils.lastDayOfMonth(date);

      final expected = DateTime.utc(2020, 12, 31);
      expect(firstDayOfMonth.day, expected.day);
      expect(firstDayOfMonth.month, expected.month);
      expect(firstDayOfMonth.year, expected.year);
    });

    test('return an utc date in Janurary 2020', () {
      final date = DateTime(2020, 1, 1);
      final firstDayOfMonth = DateUtils.lastDayOfMonth(date);

      final expected = DateTime.utc(2020, 1, 31);
      expect(firstDayOfMonth.day, expected.day);
      expect(firstDayOfMonth.month, expected.month);
      expect(firstDayOfMonth.year, expected.year);
    });
  });

  group('isSameDay tests', () {
    test('29/02/2020 should be the same day as 29/09/2020', () {
      final firstDate = DateTime(2020, 2, 29);
      final secondDate = DateTime(2020, 2, 29, 12, 12, 12);
      expect(DateUtils.isSameDay(firstDate, secondDate), true);
    });

    test('29/02/2020 should different from 01/01/2020', () {
      final firstDate = DateTime(2020, 2, 29);
      final secondDate = DateTime(2020, 1, 1, 12, 12, 12);
      expect(DateUtils.isSameDay(firstDate, secondDate), false);
    });
  });

  test('getWeekdayNumber tests', () {
    final monday = DateUtils.getWeekdayNumber(StartingDayOfWeek.monday);
    expect(monday, 1);

    final tuesday = DateUtils.getWeekdayNumber(StartingDayOfWeek.tuesday);
    expect(tuesday, 2);

    final wednesday = DateUtils.getWeekdayNumber(StartingDayOfWeek.wednesday);
    expect(wednesday, 3);

    final thursday = DateUtils.getWeekdayNumber(StartingDayOfWeek.thursday);
    expect(thursday, 4);

    final friday = DateUtils.getWeekdayNumber(StartingDayOfWeek.friday);
    expect(friday, 5);

    final saturday = DateUtils.getWeekdayNumber(StartingDayOfWeek.saturday);
    expect(saturday, 6);

    final sunday = DateUtils.getWeekdayNumber(StartingDayOfWeek.sunday);
    expect(sunday, 7);
  });

  group('getDatesInRange tests', () {
    test('get all the dates from 12/08/2020 to 16/08/2020', () {
      final firstDate = DateTime(2020, 8, 12);
      final lastDate = DateTime(2020, 8, 16);
      final dates = DateUtils.getDatesInRange(firstDate, lastDate).toList();

      expect(dates.length, lastDate.difference(firstDate).inDays + 1);

      for (int i = 0; i < dates.length; i++) {
        final date = dates[i];

        final expectedDate =
            DateTime.utc(firstDate.year, firstDate.month, firstDate.day + i);
        expect(date.day, expectedDate.day);
        expect(date.month, expectedDate.month);
        expect(date.year, expectedDate.year);
      }
    });

    test('get all the dates from 29/08/2020 to 02/09/2020', () {
      final firstDate = DateTime(2020, 8, 29);
      final lastDate = DateTime(2020, 9, 2);
      final dates = DateUtils.getDatesInRange(firstDate, lastDate).toList();

      expect(dates.length, lastDate.difference(firstDate).inDays + 1);

      for (int i = 0; i < dates.length; i++) {
        final date = dates[i];

        final expectedDate =
            DateTime.utc(firstDate.year, firstDate.month, firstDate.day + i);
        expect(date.day, expectedDate.day);
        expect(date.month, expectedDate.month);
        expect(date.year, expectedDate.year);
      }
    });

    test('get all the dates from 27/02/2020 to 02/03/2020 (leap year)', () {
      final firstDate = DateTime(2020, 2, 27);
      final lastDate = DateTime(2020, 3, 2);
      final dates = DateUtils.getDatesInRange(firstDate, lastDate).toList();

      expect(dates.length, lastDate.difference(firstDate).inDays + 1);

      for (int i = 0; i < dates.length; i++) {
        final date = dates[i];

        final expectedDate =
            DateTime.utc(firstDate.year, firstDate.month, firstDate.day + i);
        expect(date.day, expectedDate.day);
        expect(date.month, expectedDate.month);
        expect(date.year, expectedDate.year);
      }
    });

    test('get all the dates from 27/02/2019 to 02/03/2019 (non-leap year)', () {
      final firstDate = DateTime(2019, 2, 27);
      final lastDate = DateTime(2019, 3, 2);
      final dates = DateUtils.getDatesInRange(firstDate, lastDate).toList();

      expect(dates.length, lastDate.difference(firstDate).inDays + 1);

      for (int i = 0; i < dates.length; i++) {
        final date = dates[i];

        final expectedDate =
            DateTime.utc(firstDate.year, firstDate.month, firstDate.day + i);
        expect(date.day, expectedDate.day);
        expect(date.month, expectedDate.month);
        expect(date.year, expectedDate.year);
      }
    });

    test('get all the dates from 31/12/2019 to 03/01/2020', () {
      final firstDate = DateTime(2019, 12, 31);
      final lastDate = DateTime(2020, 1, 3);
      final dates = DateUtils.getDatesInRange(firstDate, lastDate).toList();

      expect(dates.length, lastDate.difference(firstDate).inDays + 1);

      for (int i = 0; i < dates.length; i++) {
        final date = dates[i];

        final expectedDate =
            DateTime.utc(firstDate.year, firstDate.month, firstDate.day + i);
        expect(date.day, expectedDate.day);
        expect(date.month, expectedDate.month);
        expect(date.year, expectedDate.year);
      }
    });
  });

  test('getNumOfWeekDaysBefore tests', () {
    final monday = DateTime(2020, 8, 17);
    expect(DateUtils.getNumOfWeekDaysBefore(monday), 0);

    final tuesday = DateTime(2020, 8, 18);
    expect(DateUtils.getNumOfWeekDaysBefore(tuesday), 1);

    final wednesday = DateTime(2020, 8, 19);
    expect(DateUtils.getNumOfWeekDaysBefore(wednesday), 2);

    final thursday = DateTime(2020, 8, 20);
    expect(DateUtils.getNumOfWeekDaysBefore(thursday), 3);

    final friday = DateTime(2020, 8, 21);
    expect(DateUtils.getNumOfWeekDaysBefore(friday), 4);

    final saturday = DateTime(2020, 8, 22);
    expect(DateUtils.getNumOfWeekDaysBefore(saturday), 5);

    final sunday = DateTime(2020, 8, 23);
    expect(DateUtils.getNumOfWeekDaysBefore(sunday), 6);
  });
}
