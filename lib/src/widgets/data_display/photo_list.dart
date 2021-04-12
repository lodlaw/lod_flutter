import 'dart:io';

import 'package:flutter/material.dart';

/// Defines the layout of the photo list
const _gridConfigs = const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 5.5,
  mainAxisSpacing: 12.0,
  crossAxisSpacing: 10.0,
);

/// Defines the spacing around the photo modal
const _photoPopUpPadding = 16.0;

/// Defines the size of the icon
const _iconSize = 16.0;

/// The photo source to be rendered from.d
enum PhotoSource { network, file }

/// Represents a photo entity
@immutable
class Photo {
  /// The source of the photo.
  final PhotoSource? source;

  /// The path to the photo source.
  final String? path;

  Photo({this.source, this.path});

  @override
  bool operator ==(other) {
    if (other is Photo) {
      return source == other.source && path == other.path;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class PhotoList extends StatelessWidget {
  /// A list of photos.
  final List<Photo> photos;

  /// Callback when the delete button is tapped.
  final Function(Photo)? onTapDelete;

  /// Renders a photo list.
  ///
  /// [photos] must not be null.
  const PhotoList({Key? key, required this.photos, this.onTapDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: _gridConfigs,
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];

        return _PhotoItem(
          photo: photos[index],
          onTapDelete: onTapDelete != null ? () => onTapDelete!(photo) : null,
          index: index,
        );
      },
    );
  }
}

class _PhotoItem extends StatelessWidget {
  /// The photo to be rendered.
  final Photo photo;

  /// Callback when the delete button is tapped.
  final Function? onTapDelete;

  /// The index of the photo in the photo list
  final int index;

  /// Renders a photo item in a photo list.
  ///
  /// [photo] and [index] must not be null.
  ///
  /// Delete button will be hidden if [onTapDelete] is null.
  const _PhotoItem({
    Key? key,
    required this.photo,
    required this.index,
    this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRemovable = onTapDelete != null;

    final inputBorderSide =
        theme.inputDecorationTheme.focusedBorder!.borderSide;

    final textStyle = theme.textTheme.button!;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(inputBorderSide),
            borderRadius: BorderRadius.circular(100000),
          ),
          child: InkWell(
            onTap: () => _onOpenPhoto(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: isRemovable ? _iconSize : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: _iconSize / 2),
                        child: Icon(
                          Icons.image,
                          size: _iconSize,
                          color: textStyle.color,
                        ),
                      ),
                      Text("Image #$index", style: textStyle)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isRemovable) _buildRemoveIcon()
      ],
    );
  }

  Widget _buildRemoveIcon() {
    return Positioned.fill(
        left: null,
        right: _iconSize / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: _iconSize,
              constraints:
                  BoxConstraints(maxHeight: _iconSize, maxWidth: _iconSize),
              icon: Icon(Icons.close),
              splashRadius: _iconSize,
              padding: EdgeInsets.zero,
              onPressed: onTapDelete as void Function()?,
            ),
          ],
        ));
  }

  void _onOpenPhoto(BuildContext context) async {
    Widget image;

    // get the appropriate image renderer
    if (photo.source == PhotoSource.file) {
      image = Image.file(File(photo.path!));
    } else {
      image = Image.network(photo.path!);
    }

    showModalBottomSheet(
        context: context,
        shape: Theme.of(context).bottomSheetTheme.shape,
        builder: (context) {
          return Wrap(children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: _photoPopUpPadding / 2),
              child: Text("Image #$index",
                  style: Theme.of(context).textTheme.subtitle1),
            )),
            Padding(
                padding: const EdgeInsets.all(_photoPopUpPadding),
                child: Card(child: image)),
          ]);
        });
  }
}
