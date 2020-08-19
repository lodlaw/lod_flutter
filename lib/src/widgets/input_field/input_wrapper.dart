import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_field.dart'
    hide TextField;

class InputWrapper extends StatelessWidget {
  final Widget input;
  final String title;
  final String hintText;
  final bool editable;
  final Function(String value) onChanged;
  final Function onTap;
  final TextEditingController controller;
  final int maxLines;

  const InputWrapper(
      {Key key,
      this.input,
      this.title,
      this.hintText = "",
      this.editable = false,
      this.onChanged,
      this.onTap,
      this.maxLines = 1,
      this.controller})
      : assert(title != null),
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
          maxLines: maxLines,
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
  final int maxLines;

  const BackgroundInput(
      {Key key,
      this.hintText,
      this.editable,
      this.onChanged,
      this.onTap,
      this.controller,
      this.title,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: (editable || onTap != null) ? null : InputField.height,
          margin: EdgeInsets.only(
              top: InputField.marginTop +
                  ((editable || onTap != null) ? 0 : InputField.height)),
          child: TextField(
            onTap: onTap,
            maxLines: maxLines,
            controller: controller,
            readOnly: !editable,
            onChanged: onChanged,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.only(top: 24, left: 12)),
          ),
        ),
        _buildBorder(context)
      ],
    );
  }

  Widget _buildBorder(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: InputField.marginTop,
    ).copyWith(top: (editable || onTap != null) ? 0 : InputField.height);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.only(left: 12),
      child: Padding(
        padding: padding,
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
