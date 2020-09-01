import 'package:flutter/material.dart';
import 'package:lod_flutter/src/utils/date_utils.dart';
import 'package:lod_flutter/src/widgets/input_field/scrolling_spinner.dart';

export 'date_field.dart';
export 'date_range_field.dart';

const double _yearScrollerWidth = 43;

abstract class DateScrollerAttributes {
  /// Callback when the value of the scroller is changed.
  Function(int) get onChanged;

  /// Value of the scroller.
  int get value;
}

class DayScroller extends StatelessWidget implements DateScrollerAttributes {
  @override
  final Function(int) onChanged;

  @override
  final int value;

  /// The date in which the day is in.
  final DateTime date;

  /// Creates a cupertino-style day scroller.
  ///
  /// Arguments [date], [onChanged] must not be null.
  ///
  /// The number of days would be reflected reactively based one [date].
  const DayScroller({
    Key key,
    @required this.onChanged,
    @required this.date,
    this.value,
  })  : assert(onChanged != null),
        super(key: key);

  int get numOfDaysInMonth => DateUtils.getDaysInMonth(date).length;

  @override
  Widget build(BuildContext context) {
    final List<String> items = [];
    for (int i = 1; i <= numOfDaysInMonth; i++) {
      items.add(processNumber(i));
    }

    return ScrollingSpinner(
      items: items,
      value: processNumber(value),
      hintText: "dd",
      onChange: (day) => onChanged(int.parse(day)),
    );
  }
}

class MonthScroller extends StatelessWidget implements DateScrollerAttributes {
  @override
  final Function(int) onChanged;

  @override
  final int value;

  /// Creates a cupertino-style month scroller.
  ///
  /// Argument [onChanged] must not be null.
  const MonthScroller({Key key, @required this.onChanged, this.value})
      : assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> items = [];
    for (int i = 1; i < 13; i++) {
      items.add(processNumber(i));
    }

    return ScrollingSpinner(
      hintText: "mm",
      onChange: (month) => onChanged(int.parse(month)),
      items: items,
      value: processNumber(value),
    );
  }
}

class YearScroller extends StatelessWidget implements DateScrollerAttributes {
  @override
  final Function(int) onChanged;

  @override
  final int value;

  /// Creates a cupertino-style month scroller.
  ///
  /// Argument [onChanged] must not be null.
  const YearScroller({Key key, @required this.onChanged, this.value})
      : assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> items = [];
    for (int i = DateTime.now().year - 1; i < DateTime.now().year + 2; i++) {
      items.add(i.toString());
    }

    return ScrollingSpinner(
        hintText: "yyyy",
        width: _yearScrollerWidth,
        onChange: (year) => onChanged(int.parse(year)),
        items: items,
        value: value.toString());
  }
}

/// Convert an int to a number format where one digit number will be padded with
/// 0s.
@visibleForTesting
String processNumber(int value) {
  final processedValue = value.toString().split('.')[0];
  if (value >= 10) {
    return processedValue;
  }

  return "0$processedValue";
}
