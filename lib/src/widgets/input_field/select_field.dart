import 'package:flutter/material.dart';
import 'package:lod_flutter/src/widgets/input_field/scrolling_spinner.dart';

import 'input_wrapper.dart';

/// The height of the selection border.
const _modalHeight = 200.0;

/// The padding between the primary input and secondary input
const _inputSpacing = 8.0;

class SelectField extends StatefulWidget {
  /// The categories to be selected from.
  final List<String> categories;

  /// Called to check if other option should be visible.
  final bool Function(String) otherOptionVisible;

  /// Called when the values of select field are changed.
  final Function(String value, String otherValue) onChanged;

  /// The initial value of the field.
  final String initialValue;

  /// The initial value of the other option field.
  final String initialSecondaryValue;

  /// The title of the main input field.
  final String title;

  /// The title of the "other" input field.
  final String secondaryTitle;

  /// The hint text of the primary field.
  final String hintText;

  /// The hint text of the secondary field.
  final String secondaryHintText;

  /// Whether or not the field is editable
  final bool editable;

  /// Creates a select field with an "other" value option.
  ///
  /// Arguments [ categories], [hintText],[secondaryHintText] must not be null.
  ///
  /// If [otherOptionVisible] is null then [initialSecondaryValue] will be
  /// discarded and other field will not be visible.
  const SelectField(
      {Key key,
      @required this.categories,
      @required this.title,
      @required this.hintText,
      this.otherOptionVisible,
      this.onChanged,
      this.initialValue,
      this.initialSecondaryValue,
      this.secondaryTitle,
      this.secondaryHintText,
      this.editable = true})
      : assert(categories != null),
        assert(hintText != null),
        assert(title != null),
        assert(otherOptionVisible != null
            ? secondaryHintText != null && secondaryTitle != null
            : true),
        super(key: key);

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  /// A controller controlling the main input field.
  final _inputController = TextEditingController();

  /// A controller controlling the other input field.
  final _customOptionController = TextEditingController();

  /// Whether or not the "other" field is visible.
  bool _isCustomOptionVisible = false;

  @override
  void initState() {
    super.initState();

    // if there is an initial value then set it to the main input
    if (widget.initialValue != null) {
      _inputController.text = widget.initialValue;
    }

    // if other value is provided then set it to the state
    if (widget.initialSecondaryValue != null &&
        widget.otherOptionVisible != null) {
      _customOptionController.text = widget.initialSecondaryValue;
      _isCustomOptionVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryInput = InputWrapper(
      controller: _inputController,
      title: widget.title,
      editable: false,
      onTap: _onSelect,
      hintText: widget.hintText,
    );

    final secondaryInput = AnimatedContainer(
        height: _isCustomOptionVisible ? null : 0,
        duration: const Duration(milliseconds: 120),
        child: Padding(
          padding: const EdgeInsets.only(top: _inputSpacing),
          child: SingleChildScrollView(
            child: InputWrapper(
              title: widget.secondaryTitle,
              controller: _customOptionController,
              editable: widget.editable,
              hintText: widget.secondaryHintText,
              onChanged: (value) => _propogateFeedback(),
            ),
          ),
        ));

    return Column(
      children: <Widget>[
        primaryInput,
        if (widget.otherOptionVisible != null) secondaryInput
      ],
    );
  }

  void _onSelect() {
    if (widget.editable) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: _modalHeight,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: ScrollingSpinner(
                height: _modalHeight,
                width: double.infinity,
                items: widget.categories,
                onChange: _setValue,
                value: _inputController.text,
                looping: false,
              ),
            );
          });
    }
  }

  void _setValue(String value) {
    _inputController.text = value;

    // set the visible of the "other" field
    if (widget.otherOptionVisible != null) {
      setState(() {
        _isCustomOptionVisible = widget.otherOptionVisible(value);
      });
    }

    _propogateFeedback();
  }

  /// Trigger callback provided by parent widget.ƒ
  void _propogateFeedback() {
    if (widget.onChanged != null)
      widget.onChanged(_isCustomOptionVisible ? null : _inputController.text,
          _isCustomOptionVisible ? _customOptionController.text : null);
  }
}
