import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_spacer.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_wrapper.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/scrolling_spinner.dart';

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
    final List<String> items = [];
    for (int i = 1; i < 32; i++) {
      items.add(_processNumber(i));
    }

    return ScrollingSpinner(
      items: items,
      defaultValue: _processNumber(value.day),
      hintText: "dd",
      onChange: (day) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(value.year, value.day, int.parse(day));
          widget.onChanged(value);
        });
      },
    );
  }

  Widget _buildMonth(TextStyle textStyle) {
    final List<String> items = [];
    for (int i = 1; i < 13; i++) {
      items.add(_processNumber(i));
    }

    return ScrollingSpinner(
      hintText: "mm",
      onChange: (month) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(value.year, int.parse(month), value.day);
          widget.onChanged(value);
        });
      },
      items: items,
      defaultValue: _processNumber(value.month),
    );
  }

  Widget _buildYear(TextStyle textStyle) {
    final List<String> items = [];
    for (int i = DateTime.now().year - 1; i < DateTime.now().year + 2; i++) {
      items.add(i.toString());
    }

    return ScrollingSpinner(
      hintText: "yyyy",
      onChange: (year) {
        setState(() {
          // TODO: Check for the validity
          value = DateTime(int.parse(year), value.month, value.day);
          widget.onChanged(value);
        });
      },
      items: items,
      defaultValue: value.year.toString(),
    );
  }

  String _processNumber(int value) {
    final processedValue = value.toString().split('.')[0];
    if (value >= 10) {
      return processedValue;
    }

    return "0$processedValue";
  }
}
