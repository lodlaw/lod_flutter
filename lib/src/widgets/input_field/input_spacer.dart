import 'package:flutter/material.dart';
import 'package:lod_flutter/src/widgets/input_field/input_field.dart';

class InputSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: InputField.height * 3.0,
        width: 8,
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: InputField.height * 3))));
  }
}
