import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/physics/infinite_scroll.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_field.dart';

typedef SelectedIndexCallback = void Function(int);

class ScrollingSpinner extends StatefulWidget {
  final DateTime time;
  final TextStyle highlightedTextStyle;
  final TextStyle normalTextStyle;
  final double itemHeight;
  final double spacing;
  final void Function(String item) onChange;
  final List<String> items;
  final String defaultValue;
  final String hintText;

  ScrollingSpinner(
      {Key key,
      this.time,
      this.highlightedTextStyle,
      this.normalTextStyle,
      this.itemHeight,
      this.spacing = 30,
      this.items,
      this.onChange,
      this.defaultValue,
      this.hintText})
      : super(key: key);

  @override
  _ScrollingSpinnerState createState() => _ScrollingSpinnerState();
}

class _ScrollingSpinnerState extends State<ScrollingSpinner> {
  ScrollController _scrollController = ScrollController();
  int _currentSelectedIndex = 3;
  bool isScrolling = false;

  double defaultItemHeight = 60;

  /// getter
  TextStyle _getHighlightedTextStyle() {
    return Theme.of(context).textTheme.subtitle1;
  }

  TextStyle _getNormalTextStyle() {
    return Theme.of(context).textTheme.subtitle1;
  }

  double _getItemHeight() {
    return InputField.height;
  }

  bool isLoop(int value) {
    return value > widget.items.length - 3;
  }

  String getSelectedItem() {
    return widget.items[_currentSelectedIndex % widget.items.length];
  }

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null) {
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i] == widget.defaultValue) {
          if (i == 0) {
            i = widget.items.length;
          }
          _currentSelectedIndex = i;
          _scrollController =
              ScrollController(initialScrollOffset: (i - 1) * _getItemHeight());
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      SizedBox(
        width: widget.spacing,
        height: _getItemHeight() * 3,
        child: spinner(
          _scrollController,
          widget.items.length,
          _currentSelectedIndex,
          1,
          (index) {
            _currentSelectedIndex = index;
            isScrolling = true;
          },
          () => isScrolling = false,
        ),
      ),
    ];
    return Stack(
      children: [
        _buildHintText(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: contents,
        ),
      ],
    );
  }

  Widget _buildHintText() {
    return Positioned.fill(
      child: Padding(
          padding: EdgeInsets.only(top: 2 * InputField.height),
          child: Text(
            widget.hintText,
            textAlign: TextAlign.center,
            style: _getNormalTextStyle().apply(fontSizeFactor: 0.9),
          )),
    );
  }

  Widget spinner(
      ScrollController controller,
      int max,
      int selectedIndex,
      int interval,
      SelectedIndexCallback onUpdateSelectedIndex,
      VoidCallback onScrollEnd) {
    /// wrapping the spinner with stack and add container above it when it's scrolling
    /// this thing is to prevent an error causing by some weird stuff like this
    /// flutter: Another exception was thrown: 'package:flutter/src/widgets/scrollable.dart': Failed assertion: line 469 pos 12: '_hold == null || _drag == null': is not true.
    /// maybe later we can find out why this error is happening
    Widget _spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() ==
              "ScrollDirection.idle") {
            if (isLoop(max)) {
              int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller.jumpTo(controller.offset + (max * _getItemHeight()));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller.jumpTo(controller.offset - (max * _getItemHeight()));
              }
            }
            setState(() {
              onScrollEnd();
              if (widget.onChange != null) {
                widget.onChange(getSelectedItem());
              }
            });
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            onUpdateSelectedIndex(
                (controller.offset / _getItemHeight()).round() + 1);
            widget.onChange(getSelectedItem());
          });
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return SizedBox(
            height: _getItemHeight(),
            width: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.items[index % widget.items.length],
                  style: selectedIndex == index
                      ? _getHighlightedTextStyle()
                      : _getNormalTextStyle(),
                ),
              ],
            ),
          );
        },
        controller: controller,
        itemCount: isLoop(max) ? max * 3 : max + 2,
        physics: InfiniteScrollPhysics(itemHeight: _getItemHeight()),
        padding: EdgeInsets.zero,
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: _spinner),
        isScrolling
            ? Positioned.fill(
                child: Container(
                color: Colors.black.withOpacity(0),
              ))
            : Container()
      ],
    );
  }
}
