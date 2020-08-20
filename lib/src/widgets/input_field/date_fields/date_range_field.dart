import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_field.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_wrapper.dart';

import 'date_field.dart';

class DateRangeField extends StatelessWidget {
  final EdgeInsets confirmButtonPadding;
  final double confirmButtonSize;

  const DateRangeField(
      {Key key,
      this.confirmButtonPadding = const EdgeInsets.symmetric(horizontal: 4.0),
      this.confirmButtonSize = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: _SimpleDateField(
          confirmButtonPadding: confirmButtonPadding,
          confirmButtonSize: confirmButtonSize,
          title: "Start Date*",
        )),
        Expanded(
          child: _SimpleDateField(
            confirmButtonPadding: confirmButtonPadding,
            confirmButtonSize: confirmButtonSize,
            title: "End Date",
          ),
        )
      ],
    );
  }
}

class _SimpleDateField extends StatefulWidget {
  final EdgeInsets confirmButtonPadding;
  final String title;
  final double confirmButtonSize;

  const _SimpleDateField(
      {Key key,
      this.title,
      this.confirmButtonPadding = const EdgeInsets.symmetric(horizontal: 4.0),
      this.confirmButtonSize = 24})
      : assert(title != null),
        super(key: key);

  @override
  __SimpleDateFieldState createState() => __SimpleDateFieldState();
}

class __SimpleDateFieldState extends State<_SimpleDateField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BackgroundInput(
                onTap: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                editable: false,
                title: widget.title,
                hintText: "dd/mm/yyyy",
              ),
            ),
            SizedBox(
                width: widget.confirmButtonSize +
                    widget.confirmButtonPadding.right +
                    widget.confirmButtonPadding.left)
          ],
        ),
        AnimatedContainer(
          height: _isVisible ? InputField.height * 3 : 0,
          duration: const Duration(milliseconds: 250),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: DateField(
                    title: null,
                    onChanged: (date) {},
                  ),
                ),
                Padding(
                  padding: widget.confirmButtonPadding,
                  child: Container(
                    width: widget.confirmButtonSize,
                    height: widget.confirmButtonSize,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000.0),
                      onTap: () {},
                      child: Icon(Icons.done, size: 18.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
