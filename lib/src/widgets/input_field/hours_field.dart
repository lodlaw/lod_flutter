import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_spacer.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_wrapper.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/scrolling_spinner.dart';

typedef OnChangedCallback = void Function(double);

class HoursField extends StatefulWidget {
  final int minHours;
  final int maxHours;
  final double defaultValue;

  const HoursField(
      {Key key, this.minHours = 0, this.maxHours = 8, this.defaultValue})
      : super(key: key);

  @override
  _HoursFieldState createState() => _HoursFieldState();
}

class _HoursFieldState extends State<HoursField> {
  double value;

  @override
  void initState() {
    super.initState();

    value = widget.maxHours.toDouble();

    if (widget.defaultValue == null) {
      value = widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subtitle1;

    return InputWrapper(
      input: Row(
        children: <Widget>[
          InputSpacer(),
          _buildHours(textStyle, value.floor()),
          InputSpacer(),
          Container(
            width: 12,
            child: Center(
              child: Text(
                ":",
                style: textStyle,
              ),
            ),
          ),
          InputSpacer(),
          _buildMinutes(textStyle, (value - value.floor()) * 60),
          InputSpacer()
        ],
      ),
    );
  }

  Widget _buildHours(TextStyle textStyle, int defaultValue) {
    final defaultValueString =
        defaultValue < 10 ? "0$defaultValue" : defaultValue.toString();
    return ScrollingSpinner(
      hintText: "hrs",
      items: _getHoursString(),
      onChange: (hours) {},
      defaultValue: defaultValueString,
    );
  }

  Widget _buildMinutes(TextStyle textStyle, double defaultValue) {
    return ScrollingSpinner(
      items: _getMinutesString(),
      defaultValue: _processNumber(defaultValue),
      hintText: "mins",
      onChange: (minutes) {},
    );
  }

  List<String> _getMinutesString() {
    final List<String> items = [];
    for (int i = 0; i < 60; i = i + 15) {
      items.add(_processNumber(i.toDouble()));
    }

    return items;
  }

  List<String> _getHoursString() {
    final List<String> items = [];
    for (int i = widget.minHours; i <= widget.maxHours; i++) {
      items.add(_processNumber(i.toDouble()));
    }

    return items;
  }

  String _processNumber(double value) {
    if (value >= 10) {
      return value.toString();
    }

    return "0$value";
  }
}
