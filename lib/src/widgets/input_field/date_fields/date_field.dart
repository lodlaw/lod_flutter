import 'package:flutter/material.dart';
import 'package:lod_flutter/lod_flutter.dart';
import 'package:lod_flutter/src/widgets/input_field/input_spacer.dart';
import 'package:lod_flutter/src/widgets/input_field/input_wrapper.dart';

class DateField extends StatefulWidget {
  /// The initial value of the field. Defaults to [DateTime.now].
  final DateTime initialValue;

  /// The title of the field.
  final String title;

  /// Called when the value of the field is changed.
  final void Function(DateTime) onChanged;

  /// The identifier of the field
  final keyPrefix;

  /// Creates an uncontrolled date field.
  ///
  /// The [onChanged] argument must not be null.
  ///
  /// If [title] is null, the spinners will be horizontally centered.
  const DateField({
    Key key,
    @required this.onChanged,
    this.initialValue,
    this.title = "Date",
    this.keyPrefix = "",
  })  : assert(onChanged != null),
        super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime value = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subtitle1;

    return InputWrapper(
      title: widget.title,
      input: Row(
        children: <Widget>[
          InputSpacer(),
          _buildDayScroller(textStyle),
          InputSpacer(),
          _buildMonthScroller(textStyle),
          InputSpacer(),
          _buildYearScroller(textStyle),
          InputSpacer()
        ],
      ),
    );
  }

  Widget _buildDayScroller(TextStyle textStyle) {
    return DayScroller(
      key: ValueKey('${widget.keyPrefix}dayPicker'),
      date: value,
      onChanged: (day) {
        setState(() {
          value = DateTime(value.year, value.month, day);
          widget.onChanged(value);
        });
      },
      value: value.day,
    );
  }

  Widget _buildMonthScroller(TextStyle textStyle) {
    return MonthScroller(
      key: ValueKey('${widget.keyPrefix}monthPicker'),
      onChanged: (month) {
        final newDate = DateTime(value.year, month, value.day);

        setState(() {
          // Because some months can have 30 days and others can have 31 days,
          // sometimes it will display the incorrect value.
          //
          // If the value is incorrect, set the value to be the first day of
          // the selected month
          if (newDate.month == month) {
            value = newDate;
            if (widget.onChanged != null) widget.onChanged(value);
          } else {
            value = DateTime(value.year, month, 1);
          }
        });
      },
      value: value.month,
    );
  }

  Widget _buildYearScroller(TextStyle textStyle) {
    return YearScroller(
      key: ValueKey('${widget.keyPrefix}yearPicker'),
      onChanged: (year) {
        setState(() {
          value = DateTime(year, value.month, value.day);
          widget.onChanged(value);
        });
      },
      value: value.year,
    );
  }
}
