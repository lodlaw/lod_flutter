import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lod_flutter/src/widgets/input_field/input_field.dart';
import 'package:lod_flutter/src/widgets/input_field/input_wrapper.dart';

import 'date_field.dart';

const _confirmButtonPaddingFactor = 1 / 8;
const _confirmButtonIconSizeFactor = 2 / 3;

/// An encapsulation of start date and end date
@immutable
class DateRange {
  /// The end date
  final DateTime start;

  /// The start date
  final DateTime end;

  /// Creates a date range for the given start and end [DateTime]
  DateRange({@required this.start, @required this.end});
}

class DateRangeField extends StatefulWidget {
  /// The size of the button.
  ///
  /// The padding of the button will be derived from the size in accordance
  /// with [_confirmButtonPaddingFactor]
  final double confirmButtonSize;

  /// The right padding of the presentation component of the field.
  final double rightPaddingSize;

  /// Callback when the value of the field is changed.
  final ValueChanged<DateRange> onChanged;

  /// The initial value of the field.
  final DateRange initialValue;

  /// The title of the start date repr field.
  final String startDateTitle;

  /// The title of the end date repr field.
  final String endDateTitle;

  /// Whether or not the field can be amended
  final bool editable;

  /// Creates a date range spinner that includes start date and end date
  ///
  /// Argument [onChanged] must not be null
  const DateRangeField(
      {Key key,
      this.rightPaddingSize = 30,
      @required this.onChanged,
      this.confirmButtonSize = 30,
      this.initialValue,
      this.startDateTitle = "Start Date*",
      this.endDateTitle = "End Date",
      this.editable = true})
      : assert(onChanged != null),
        super(key: key);

  @override
  _DateRangeFieldState createState() => _DateRangeFieldState();
}

class _DateRangeFieldState extends State<DateRangeField> {
  bool _isStartDateVisible = false;
  bool _isEndDateVisible = false;

  final _reprStartDateFieldController = TextEditingController();
  final _reprEndDateFieldController = TextEditingController();

  DateRange _value = DateRange(start: DateTime.now(), end: DateTime.now());
  DateRange _dirtyValue = DateRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      _value = widget.initialValue;
      _dirtyValue = widget.initialValue;
    }

    _updateRepr(onChangedCallback: false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: _SimpleDateField(
          reprFieldController: _reprStartDateFieldController,
          confirmButtonSize: widget.confirmButtonSize,
          title: widget.startDateTitle,
          rightPaddingSize: widget.rightPaddingSize,
          onOpenSelection: _onOpenStartDateSelection,
          isVisible: _isStartDateVisible,
          onCancelSelection: _onCancelStartDateSelection,
          onChanged: _onChangedStartDate,
          onTapOk: _onStartDateOk,
          initialValue: widget.initialValue?.start,
        )),
        Expanded(
          child: _SimpleDateField(
            reprFieldController: _reprEndDateFieldController,
            confirmButtonSize: widget.confirmButtonSize,
            title: widget.endDateTitle,
            rightPaddingSize: widget.rightPaddingSize,
            onOpenSelection: _onOpenEndDateSelection,
            isVisible: _isEndDateVisible,
            onCancelSelection: _onCancelEndDateSelection,
            onChanged: _onChangedEndDate,
            onTapOk: _onEndDateOk,
            initialValue: widget.initialValue?.end,
          ),
        )
      ],
    );
  }

  void _onOpenStartDateSelection() {
    if (widget.editable) {
      setState(() {
        _isStartDateVisible = true;
      });
    }
  }

  void _onOpenEndDateSelection() {
    if (widget.editable) {
      setState(() {
        _isEndDateVisible = true;
      });
    }
  }

  void _onCancelStartDateSelection() {
    setState(() {
      _isStartDateVisible = false;
    });
  }

  void _onCancelEndDateSelection() {
    setState(() {
      _isEndDateVisible = false;
    });
  }

  void _onChangedStartDate(DateTime startDate) {
    setState(() {
      _dirtyValue = DateRange(start: startDate, end: _dirtyValue.end);
    });
  }

  void _onChangedEndDate(DateTime endDate) {
    setState(() {
      _dirtyValue = DateRange(start: _dirtyValue.start, end: endDate);
    });
  }

  void _onStartDateOk() {
    final start = _dirtyValue.start;

    // set start date to end date if it is before the start date
    final end = _value.end.isBefore(start) ? start : _value.end;

    setState(() {
      _isStartDateVisible = false;
      _value = DateRange(start: start, end: end);
      _updateRepr();
    });
  }

  void _onEndDateOk() {
    final end = _dirtyValue.end;

    // set end date to start date if it is after the end date
    final start = end.isBefore(_value.start) ? end : _value.start;

    setState(() {
      _isEndDateVisible = false;
      _value = DateRange(start: start, end: end);
    });

    _updateRepr();
  }

  void _updateRepr({bool onChangedCallback = true}) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    _reprEndDateFieldController.text = dateFormat.format(_value.end);
    _reprStartDateFieldController.text = dateFormat.format(_value.start);

    if (onChangedCallback) widget.onChanged(_value);
  }
}

class _SimpleDateField extends StatelessWidget {
  /// The title of the field.
  final String title;

  /// The size of the ok button. The padding of the button will be derived from
  /// this side according to [_confirmButtonPaddingFactor].
  final double confirmButtonSize;

  /// The right padding of the presentational component.
  final double rightPaddingSize;

  /// Whether or not the selection is visible.
  final bool isVisible;

  /// Called when the selection is about to open from a closed state
  final Function onOpenSelection;

  /// Called when the selection is about to close from an open state
  final Function onCancelSelection;

  /// The controller of the presentational field.
  final TextEditingController reprFieldController;

  /// Callback when the value is changed.
  final ValueChanged<DateTime> onChanged;

  /// Callback when confirmation button is tapped.
  final Function onTapOk;

  /// The initial value of the field
  final DateTime initialValue;

  /// Creates a repr component and selector component for a date.
  ///
  /// All arguments are required and not null except [initialValue].
  const _SimpleDateField({
    Key key,
    @required this.rightPaddingSize,
    @required this.isVisible,
    @required this.onCancelSelection,
    @required this.onOpenSelection,
    @required this.reprFieldController,
    @required this.title,
    @required this.confirmButtonSize,
    @required this.onChanged,
    @required this.onTapOk,
    this.initialValue,
  })  : assert(rightPaddingSize != null),
        assert(title != null),
        assert(onOpenSelection != null),
        assert(isVisible != null),
        assert(onCancelSelection != null),
        assert(reprFieldController != null),
        assert(confirmButtonSize != null),
        assert(onChanged != null),
        assert(onTapOk != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildReprField(), _buildSelectionField()],
    );
  }

  Widget _buildReprField() {
    return Padding(
      padding: EdgeInsets.only(right: rightPaddingSize),
      child: BackgroundInput(
        onTap: _onTapReprField,
        editable: false,
        title: title,
        hintText: "dd/mm/yyyy",
        controller: reprFieldController,
      ),
    );
  }

  Widget _buildSelectionField() {
    final buttonSize = max(confirmButtonSize, rightPaddingSize);
    final confirmButtonPaddingSize = buttonSize * _confirmButtonPaddingFactor;

    final double fieldHeight = isVisible ? InputField.height * 3 : 0;

    return AnimatedContainer(
      height: fieldHeight,
      duration: const Duration(milliseconds: 250),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DateField(
                title: null,
                onChanged: onChanged,
                initialValue: initialValue,
              ),
            ),
            _ConfirmButton(
              buttonSize: buttonSize,
              paddingSize: confirmButtonPaddingSize,
              onTap: onTapOk,
            )
          ],
        ),
      ),
    );
  }

  void _onTapReprField() {
    isVisible ? onCancelSelection() : onOpenSelection();
  }
}

class _ConfirmButton extends StatelessWidget {
  /// The size of the button.
  final double buttonSize;

  /// The padding around the button.
  final double paddingSize;

  /// Callback when the button is tapped.
  final Function onTap;

  /// Creates a confirmation button.
  ///
  /// [buttonSize] and [paddingSize] and [onTap] arguments must not be null.
  const _ConfirmButton(
      {Key key,
      @required this.buttonSize,
      @required this.paddingSize,
      @required this.onTap})
      : assert(buttonSize != null),
        assert(paddingSize != null),
        assert(onTap != null),
        super(key: key);

  static final borderRadius = BorderRadius.circular(100);

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).inputDecorationTheme.focusedBorder.borderSide.color;

    final actualButtonSize = buttonSize - paddingSize;
    final iconSize = actualButtonSize * _confirmButtonIconSizeFactor;

    final button = InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.0),
            borderRadius: borderRadius,
          ),
          child: Icon(
            Icons.done,
            size: iconSize,
            color: color,
          ),
        ));

    return Container(
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.all(paddingSize),
      margin: EdgeInsets.only(top: InputField.marginTop),
      child: Container(
        width: actualButtonSize,
        child: button,
      ),
    );
  }
}
