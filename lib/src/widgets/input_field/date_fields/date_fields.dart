import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/scrolling_spinner.dart';

export 'date_field.dart';
export 'date_range_field.dart';

class DayScroller extends StatelessWidget {
  final Function(int) onChanged;
  final int defaultValue;

  const DayScroller({Key key, @required this.onChanged, this.defaultValue})
      : assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> items = [];
    for (int i = 1; i < 32; i++) {
      items.add(_processNumber(i));
    }

    return ScrollingSpinner(
      items: items,
      defaultValue: _processNumber(defaultValue),
      hintText: "dd",
      onChange: (day) => int.parse(day),
    );
  }
}

class MonthScroller extends StatelessWidget {
  final Function(int) onChanged;
  final int defaultValue;

  const MonthScroller({Key key, @required this.onChanged, this.defaultValue})
      : assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> items = [];
    for (int i = 1; i < 13; i++) {
      items.add(_processNumber(i));
    }

    return ScrollingSpinner(
      hintText: "mm",
      onChange: (month) => int.parse(month),
      items: items,
      defaultValue: _processNumber(defaultValue),
    );
  }
}

class YearScroller extends StatelessWidget {
  final Function(int) onChanged;
  final int defaultValue;

  const YearScroller({Key key, @required this.onChanged, this.defaultValue})
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
        spacing: 43,
        onChange: (year) => onChanged(int.parse(year)),
        items: items,
        defaultValue: defaultValue.toString());
  }
}

String _processNumber(int value) {
  final processedValue = value.toString().split('.')[0];
  if (value >= 10) {
    return processedValue;
  }

  return "0$processedValue";
}
