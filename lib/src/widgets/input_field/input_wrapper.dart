import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_field.dart';

class InputWrapper extends StatelessWidget {
  final Widget input;
  final String title;
  final String hintText;
  final bool editable;
  final Function(String value) onChanged;
  final Function onTap;
  final TextEditingController controller;

  const InputWrapper(
      {Key key,
      this.input,
      this.title,
      this.hintText = "",
      this.editable = false,
      this.onChanged,
      this.onTap,
      this.controller})
      : assert(input != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (input == null) {
      return BackgroundInput(
          editable: editable,
          hintText: hintText,
          onChanged: onChanged,
          onTap: onTap,
          title: title,
          controller: controller);
    }
    return Stack(
      children: <Widget>[
        BackgroundInput(
            editable: editable,
            hintText: hintText,
            onChanged: onChanged,
            onTap: onTap,
            title: title,
            controller: controller),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: InputField.height, top: InputField.marginTop),
              child: input,
            ),
          ],
        )
      ],
    );
  }
}

class BackgroundInput extends StatelessWidget {
  final String hintText;
  final bool editable;
  final Function(String value) onChanged;
  final Function onTap;
  final TextEditingController controller;
  final String title;

  const BackgroundInput(
      {Key key,
      this.hintText,
      this.editable,
      this.onChanged,
      this.onTap,
      this.controller,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: InputField.height,
          margin: EdgeInsets.only(
              top: InputField.marginTop +
                  ((editable || onTap != null) ? 0 : InputField.height)),
          child: TextField(
            onTap: onTap,
            controller: controller,
            readOnly: !editable,
            onChanged: onChanged,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.only(top: 4, left: 12)),
          ),
        ),
        _buildBorder(context)
      ],
    );
  }

  Widget _buildBorder(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.only(left: 12),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: InputField.marginTop,
            vertical: (editable || onTap != null) ? 0 : InputField.height),
        child: Text(title,
            style: Theme.of(context).textTheme.subtitle1.apply(
                color: Theme.of(context)
                    .inputDecorationTheme
                    .focusedBorder
                    .borderSide
                    .color)),
      ),
    );
  }
}
