import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

const _buttonSize = 26.0;
const _iconSize = 20.0;

class DateCard extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final Widget middleSection;
  final Widget bottomSection;
  final Widget editScreen;
  final Function? onTapDelete;

  const DateCard(
      {Key? key,
      required this.title,
      required this.leading,
      required this.middleSection,
      required this.bottomSection,
      required this.editScreen,
      this.onTapDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      child: ListTile(
        contentPadding: EdgeInsets.all(6),
        leading: leading,
        title: title,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: middleSection,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      if (onTapDelete != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: DateCardButton(
                            iconData: Icons.close,
                            onPressed: onTapDelete,
                          ),
                        ),
                      IconButtonWithOpenContainerTransition(
                        iconData: Icons.edit,
                        screen: editScreen,
                      ),
                    ],
                  )
                ],
              ),
            ),
            bottomSection,
          ],
        ),
      ),
    );
  }
}

class DateCardButton extends StatelessWidget {
  const DateCardButton({Key? key, this.onPressed, this.iconData})
      : super(key: key);

  final Function? onPressed;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonSize,
      height: _buttonSize,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.0,
            // color: Theme.of(context).buttonTheme.colorScheme.primary
          ),
        ),
        child: InkWell(
            onTap: onPressed as void Function()?,
            child: Icon(
              iconData,
              size: _iconSize,
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
            )),
      ),
    );
  }
}

class IconButtonWithOpenContainerTransition extends StatelessWidget {
  final Widget screen;
  final IconData iconData;
  final Color color;

  const IconButtonWithOpenContainerTransition(
      {Key? key,
      required this.screen,
      required this.iconData,
      this.color = const Color(0xFF6E7781)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _buttonSize,
      width: _buttonSize,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.0),
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () {},
          child: OpenContainer(
            tappable: true,
            openBuilder: (BuildContext context, VoidCallback _) {
              return screen;
            },
            closedElevation: 0.0,
            closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_buttonSize / 2),
                ),
                side: BorderSide(width: 1.0, color: color)),
            closedColor: Colors.transparent,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return Icon(Icons.edit, size: _iconSize, color: color);
            },
          ),
        ),
      ),
    );
  }
}
