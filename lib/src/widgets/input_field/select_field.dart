import 'package:flutter/material.dart';

import 'input_wrapper.dart';

class SelectField extends StatefulWidget {
  final List<String> categories;
  final bool Function(String) otherOptionVisible;
  final Function(String value, String otherValue) onChanged;
  final String initialValue;
  final String initialSecondaryValue;

  const SelectField(
      {Key key,
      @required this.categories,
      this.otherOptionVisible,
      this.onChanged,
      this.initialValue,
      this.initialSecondaryValue})
      : assert(categories != null),
        super(key: key);

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  final _inputController = TextEditingController();
  final _customOptionController = TextEditingController();
  bool _isCustomOptionVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      _inputController.text = widget.initialValue;
    }

    if (widget.initialSecondaryValue != null) {
      _customOptionController.text = widget.initialSecondaryValue;
      _isCustomOptionVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InputWrapper(
          controller: _inputController,
          title: "Activity description",
          editable: false,
          onTap: _onSelect,
          hintText: "Describe the activity in your area of focus",
        ),
        AnimatedContainer(
            height: _isCustomOptionVisible ? null : 0,
            duration: const Duration(milliseconds: 120),
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SingleChildScrollView(
                child: InputWrapper(
                  title: "Your custom category",
                  input: Container(),
                  key: ValueKey('customTrainingCategoryInput'),
                  controller: _customOptionController,
                  editable: true,
                  hintText: "Type in your area of focus",
                  onChanged: (value) {
                    if (widget.onChanged != null)
                      widget.onChanged(
                          _isCustomOptionVisible ? null : _inputController.text,
                          _isCustomOptionVisible ? value : null);
                  },
                ),
              ),
            )),
      ],
    );
  }

  void _onSelect() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ChoicePicker(
              items: widget.categories,
              initialValue: _inputController.text.isEmpty
                  ? widget.categories.first
                  : _inputController.text,
              onChanged: (value) {
                _inputController.text = value;

                if (widget.otherOptionVisible != null) {
                  setState(() {
                    _isCustomOptionVisible = widget.otherOptionVisible(value);
                  });
                }
                if (widget.onChanged != null)
                  widget.onChanged(
                      _isCustomOptionVisible ? null : value,
                      _isCustomOptionVisible
                          ? _customOptionController.text
                          : null);
              },
            ),
          );
        });
  }
}

class ChoicePicker extends StatefulWidget {
  ChoicePicker({
    Key key,
    this.selectedKey,
    @required this.items,
    @required this.initialValue,
    @required this.onChanged,
  })  : assert(items != null),
        super(key: key);

  // key for selected item
  final Key selectedKey;

  // Events
  final ValueChanged<String> onChanged;

  // Variables
  final List<String> items;
  final String initialValue;

  @override
  _ChoicePickerState createState() => _ChoicePickerState(initialValue);
}

class _ChoicePickerState extends State<ChoicePicker> {
  _ChoicePickerState(this.selectedValue);

  static const double itemHeight = 50.0;

  double widgetHeight;
  int numberOfVisibleItems;
  int numberOfPaddingRows;
  double visibleItemsHeight;
  double offset;

  String selectedValue;

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    int initialItem = widget.items.indexOf(selectedValue);

    scrollController = FixedExtentScrollController(initialItem: initialItem);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged(selectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle defaultStyle = themeData.textTheme.bodyText2;
    TextStyle selectedStyle = themeData.textTheme.headline5;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            GestureDetector(
              onTapUp: _itemTapped,
              child: ListWheelScrollView.useDelegate(
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (BuildContext context, int index) {
                  if (index < 0 || index > widget.items.length - 1) {
                    return null;
                  }

                  var value = widget.items[index];

                  final isSelected = value == selectedValue;

                  final TextStyle itemStyle =
                      (value == selectedValue) ? selectedStyle : defaultStyle;

                  return Center(
                    child: Text(value,
                        style: itemStyle,
                        key: isSelected ? widget.selectedKey : null),
                  );
                }),
                controller: scrollController,
                itemExtent: itemHeight,
                onSelectedItemChanged: _onSelectedItemChanged,
                physics: FixedExtentScrollPhysics(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  key: ValueKey('scrollPickerUpper'),
                ),
                Center(
                  child: Container(
                    height: itemHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: selectedStyle.color, width: 1.0),
                        bottom:
                            BorderSide(color: selectedStyle.color, width: 1.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  key: ValueKey('scrollPickerLower'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController.offset + changeBy;

    // animate to and center on the selected item
    scrollController.animateTo(newPosition,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onSelectedItemChanged(int index) {
    String newValue = widget.items[index];
    if (newValue != selectedValue) {
      setState(() {
        selectedValue = newValue;
        widget.onChanged(newValue);
      });
    }
  }
}
