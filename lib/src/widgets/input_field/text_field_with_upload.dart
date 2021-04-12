import 'package:flutter/material.dart' hide TextField;
import 'package:image_picker/image_picker.dart';
import 'package:lod_flutter/src/widgets/data_display/photo_list.dart';

import 'input_field.dart';

const _uploadButtonSize = 40.0;
const _uploadButtonHorizontalSize = 6.0;
const _maxLines = 3;

class TextFieldWithUpload extends StatefulWidget {
  /// The initial value of the field
  final String? initialValue;

  /// The title of the field.
  final String title;

  /// Callback when the value is changed.
  final ValueChanged<String> onChanged;

  /// The hint text of the field.
  final String hintText;

  /// The controller of the field.
  final TextEditingController? controller;

  /// Callback when an image is picked.
  final Future<Photo> Function(PickedFile?) onSelectFile;

  /// The source of the list of photos.
  final PhotoSource photoSource;

  /// A list of photos.
  final List<Photo>? initialPhotos;

  /// Callback when delete button is tapped.
  final ValueChanged<Photo>? onTapDelete;

  /// Creates a text field with upload functionalities being on the right.
  ///
  /// Arguments [title], [onChanged], [hinText], [onSelect] must be provided.
  const TextFieldWithUpload({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.hintText,
    required this.onSelectFile,
    this.photoSource = PhotoSource.network,
    this.initialValue,
    this.controller,
    this.initialPhotos,
    this.onTapDelete,
  }) : super(key: key);

  @override
  _TextFieldWithUploadState createState() => _TextFieldWithUploadState();
}

class _TextFieldWithUploadState extends State<TextFieldWithUpload> {
  TextEditingController? _controller = TextEditingController();
  String? _value = "";
  final _picker = ImagePicker();
  List<Photo>? _photos = [];

  /// whether or not the input is being focused on because we need to update the
  /// UI for update section
  bool _isFocused = false;

  void initState() {
    super.initState();

    // if the initial value is provided then set it to the state
    if (widget.initialValue != null) {
      _value = widget.initialValue;
    }

    // if the controller is provided then set it to the state
    if (widget.controller != null) {
      _controller = widget.controller;
    }

    if (widget.initialPhotos != null) {
      _photos = widget.initialPhotos;
    }

    // set the initial UI
    _controller!.text = _value!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _TextField(
                controller: _controller!,
                onFocusChanged: _setFocus,
                hintText: widget.hintText,
                title: widget.title,
                onChanged: widget.onChanged),
            // the upload section will be positioned to the right
            Positioned.fill(
                right: 0,
                left: null,
                child: _UploadSection(
                  isFocused: _isFocused,
                  onTapCameraUpload: _onTapCameraUpload,
                  onTapPhotoUpload: _onTapPhotoUpload,
                )),
          ],
        ),
        if (_photos!.isNotEmpty) _buildPhotoList()
      ],
    );
  }

  Widget _buildPhotoList() {
    return Column(
      children: [
        SizedBox(
          height: _uploadButtonSize / 4,
        ),
        PhotoList(
          photos: _photos!,
          onTapDelete: widget.onTapDelete != null
              ? (value) {
                  setState(() {
                    _photos =
                        _photos!.where((element) => element != value).toList();
                  });
                  widget.onTapDelete!(value);
                }
              : null,
        )
      ],
    );
  }

  Future _onTapCameraUpload() async => await _onTapUpload(ImageSource.camera);

  Future _onTapPhotoUpload() async => await _onTapUpload(ImageSource.gallery);

  Future _onTapUpload(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    final savedFile = await widget.onSelectFile(pickedFile);

    setState(() {
      _photos = [..._photos!, savedFile];
    });
  }

  void _setFocus(bool isFocus) {
    setState(() {
      _isFocused = isFocus;
    });
  }
}

class _TextField extends StatelessWidget {
  /// Callback when the focus of the field has been changed.
  final ValueChanged<bool> onFocusChanged;

  /// The controller of the field.
  final TextEditingController controller;

  /// The title of the field.
  final String title;

  /// The hint text of the field
  final String hintText;

  /// Callback when value is changed
  final ValueChanged<String> onChanged;

  /// Create a wrapper around the text editting theme with a content padding.
  const _TextField(
      {Key? key,
      required this.onFocusChanged,
      required this.controller,
      required this.hintText,
      required this.title,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // the actual input field with a focused callback
    final inputField = Focus(
      onFocusChange: onFocusChanged,
      child: TextField(
        maxLines: _maxLines,
        controller: controller,
        title: title,
        hintText: hintText,
        onChanged: onChanged,
      ),
    );

    return Theme(
      data: _getTheme(context),
      child: inputField,
    );
  }

  /// get the theme with a right content padding equal to the
  /// width of [_uploadButtonSize]
  ThemeData _getTheme(BuildContext context) {
    final oldTheme = Theme.of(context);

    final rightPadding = EdgeInsets.only(right: _uploadButtonSize);

    final oldInputDecorationTheme = oldTheme.inputDecorationTheme;
    final newInputDecorationTheme = oldInputDecorationTheme.copyWith(
      contentPadding: rightPadding,
    );

    return oldTheme.copyWith(inputDecorationTheme: newInputDecorationTheme);
  }
}

class _UploadSection extends StatelessWidget {
  /// Whether or not the field is being focused on.
  final bool isFocused;

  /// Callback when the camera button is tapped.
  final Function? onTapCameraUpload;

  /// Callback when the photo button is tapped.
  final Function? onTapPhotoUpload;

  /// Creates an upload section with camera on top of the photo.
  ///
  /// Argument [isFocused] must not be null because this is a dependency of the
  /// text area.
  ///
  /// Either [onTapCameraUpload] or [onTapPhotoUpload] must be present. If one
  /// is not present, the functionality will be disabled.
  const _UploadSection(
      {Key? key,
      required this.isFocused,
      this.onTapCameraUpload,
      this.onTapPhotoUpload})
      : assert(onTapCameraUpload != null || onTapPhotoUpload != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    final enabledBorder = inputDecorationTheme.enabledBorder;
    final focusedBorder = inputDecorationTheme.focusedBorder;

    final borderColor = isFocused
        ? focusedBorder!.borderSide.color
        : enabledBorder!.borderSide.color;

    final borderWidth = inputDecorationTheme.enabledBorder!.borderSide.width;

    return Container(
      width: _uploadButtonSize,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: InputField.borderRadius,
              topRight: InputField.borderRadius)),
      child: Container(
        margin: EdgeInsets.only(
            right: borderWidth,
            top: borderWidth + InputField.marginTop,
            bottom: borderWidth),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: borderColor, width: borderWidth))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (onTapCameraUpload != null)
              Expanded(
                  child: _UploadButton(
                iconData: Icons.camera_alt,
                onTap: onTapCameraUpload!,
              )),
            if (onTapPhotoUpload != null)
              Expanded(
                  child: _UploadButton(
                iconData: Icons.photo,
                onTap: onTapPhotoUpload!,
              )),
          ],
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  /// The icon of the button.
  final IconData iconData;

  /// Callback when the button is tapped.
  final Function onTap;

  /// Creates an upload button for a given icon.
  ///
  /// [onTap] and [iconData] must not be null.
  const _UploadButton({Key? key, required this.iconData, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWrapper = Padding(
      padding: EdgeInsets.symmetric(horizontal: _uploadButtonHorizontalSize),
      child: Icon(iconData),
    );

    return InkWell(
      borderRadius: BorderRadius.only(topRight: InputField.borderRadius),
      onTap: onTap as void Function()?,
      child: buttonWrapper,
    );
  }
}
