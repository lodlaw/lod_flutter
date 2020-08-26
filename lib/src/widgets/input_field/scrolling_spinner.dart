import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lodlaw_flutter/src/widgets/input_field/input_field.dart';

const _squeeze = 0.9;
const _diameterRatio = 1.9;
const _numOfRenderedElements = 3;
const double _width = 30;

class ScrollingSpinner extends StatefulWidget {
  /// The width of the spinner
  final double width;

  /// Callback when an item is changed
  final Function(String item) onChange;

  /// A list of items to be rendered
  final List<String> items;

  /// The current value of the spinner
  final String value;

  /// Hint text for the spinner
  final String hintText;

  /// An uncontrolled cupertino style loop spinner
  ScrollingSpinner({
    Key key,
    this.width = _width,
    this.items,
    this.onChange,
    this.value,
    this.hintText = "",
  })  : assert(hintText != null),
        super(key: key);

  @override
  _ScrollingSpinnerState createState() => _ScrollingSpinnerState();
}

class _ScrollingSpinnerState extends State<ScrollingSpinner> {
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    // find the position of the value and go to that position in the first render
    if (widget.value != null) {
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i] == widget.value) {
          _scrollController = FixedExtentScrollController(initialItem: i);
          break;
        }
      }
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if list of items has changed, find the new position for the updated value
    // and go to that position
    if (oldWidget.items.length != widget.items.length) {
      int updatedPosition;

      // find the new position of the item
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i] == widget.value) {
          updatedPosition = i;
        }
      }

      if (updatedPosition != null) {
        // this must be rendered in the next frame because jumpToItem will be
        // rendered during setState
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpToItem(updatedPosition);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinner = SizedBox(
      width: widget.width,
      height: _getItemHeight() * _numOfRenderedElements,
      child: CupertinoPicker(
        scrollController: _scrollController,
        itemExtent: _getItemHeight(),
        onSelectedItemChanged: (index) {
          widget.onChange(widget.items[index]);
        },
        squeeze: _squeeze,
        diameterRatio: _diameterRatio,
        looping: true,
        children: widget.items
            .map((e) => SpinningItem(
                  content: e,
                ))
            .toList(),
      ),
    );

    return Stack(
      children: [
        HintText(
          content: widget.hintText,
        ),
        spinner,
      ],
    );
  }

  double _getItemHeight() {
    return InputField.height;
  }
}

@visibleForTesting
class SpinningItem extends StatelessWidget {
  /// The text to be displayed
  final String content;

  /// The spinning item
  const SpinningItem({Key key, @required this.content})
      : assert(content != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          content,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

@visibleForTesting
class HintText extends StatelessWidget {
  /// The text to be displayed
  final String content;

  /// The hint text to be displayed under the selected item of the
  /// spinner
  const HintText({Key key, @required this.content})
      : assert(content != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
          padding: EdgeInsets.only(top: 2 * InputField.height),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .apply(fontSizeFactor: 0.9),
          )),
    );
  }
}