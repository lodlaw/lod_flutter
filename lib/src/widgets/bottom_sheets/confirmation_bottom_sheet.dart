import 'package:flutter/material.dart';

showConfirmationBottomSheet({required BuildContext context,
  required String title,
  String okText = "CONTINUE",
  String cancelText = "CANCEL",
  Function(BuildContext context)? onOk,
  Function(BuildContext context)? onCancel}) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      builder: (context) {
        final textStyle = Theme
            .of(context)
            .textTheme
            .subtitle1!
            .copyWith(
          letterSpacing: 1.4,
          wordSpacing: 1.4,
        );
        final buttonTextStyle = textStyle.apply(fontSizeFactor: 0.9);

        final color = textStyle.color!;
        final cancelColor = color.withOpacity(0.65);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * (6 / 7)),
                    child: Text(
                      title,
                      style: textStyle.copyWith(height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(
                    child: Text(
                      cancelText,
                      style: buttonTextStyle.copyWith(color: cancelColor),
                    ),
                    onPressed: () => onCancel!(context),
                    color: cancelColor,
                  ),
                  _buildButton(
                    child: Text(
                      okText,
                      style: buttonTextStyle,
                    ),
                    onPressed: () => onOk!(context),
                    color: color,
                  )
                ],
              ),
            ],
          ),
        );
      });
}

Widget _buildButton({
  required Widget child,
  required VoidCallback onPressed,
  required Color color,
}) {
  if (Platform.isIOS) {
    return CupertinoOutlineButton(
      child: child,
      onPressed: onPressed,
      borderColor: color,
    );
  }
  return OutlineButton(
    child: child,
    onPressed: onPressed,
    textColor: color,
    borderSide: BorderSide(color: color),
    highlightedBorderColor: color,
  );
}
