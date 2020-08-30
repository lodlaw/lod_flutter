import 'package:flutter/material.dart' hide TextField;
import 'package:lodlaw_flutter/src/widgets/input_field/input_wrapper.dart';

class TextField extends StatefulWidget {
  final String defaultValue;
  final String title;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final TextEditingController controller;
  final String hintText;

  const TextField(
      {Key key,
      this.defaultValue,
      this.title = "Text Field",
      this.onChanged,
      this.maxLines = 1,
      this.hintText,
      this.controller})
      : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  String value = "";

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null) {
      value = widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      title: widget.title,
      hintText: widget.hintText,
      maxLines: widget.maxLines,
      controller: widget.controller,
      onChanged: (value) {
        print(value);
      },
      editable: true,
    );
  }
}
