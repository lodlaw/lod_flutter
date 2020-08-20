import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/lodlaw_flutter.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_spacer.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_wrapper.dart';

class DateField extends StatefulWidget {
  final DateTime defaultValue;
  final String title;
  final void Function(DateTime) onChanged;

  const DateField(
      {Key key, this.defaultValue, this.title = "Date", this.onChanged})
      : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime value;

  @override
  void initState() {
    super.initState();

    value = DateTime.now();

    if (widget.defaultValue != null) {
      value = widget.defaultValue;
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
          _buildDay(textStyle),
          InputSpacer(),
          _buildMonth(textStyle),
          InputSpacer(),
          _buildYear(textStyle),
          InputSpacer()
        ],
      ),
    );
  }

  Widget _buildDay(TextStyle textStyle) {
    return DayScroller(
      onChanged: (day) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(value.year, value.day, day);
          widget.onChanged(value);
        });
      },
      defaultValue: value.day,
    );
  }

  Widget _buildMonth(TextStyle textStyle) {
    return MonthScroller(
      onChanged: (month) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(value.year, month, value.day);
          widget.onChanged(value);
        });
      },
      defaultValue: value.month,
    );
  }

  Widget _buildYear(TextStyle textStyle) {
    return YearScroller(
      onChanged: (year) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(year, value.month, value.day);
          widget.onChanged(value);
        });
      },
      defaultValue: value.year,
    );
  }
}
