part of 'carousel.dart';

const _dotSpaceFactor = 1.5;
const _dotColorFactor = 0.5;

class DotIndicatorCarousel extends StatefulWidget {
  /// The total number of items of the carousel.
  final int itemCount;

  /// Builder function for an item.
  final Widget Function(BuildContext context, int selectedIndex) itemBuilder;

  /// The color of the dot.
  ///
  /// Inactive dot will have the color equal to [_dotColorFactor] of the normal
  /// color.
  final Color dotColor;

  /// The size of the dot.
  final double dotSize;

  /// The space around the dot.
  ///
  /// Vertical space will be [_dotSpaceFactor] horizontal space.
  final double dotSpace;

  /// Creates a carousel with the dot indicator being at the bottom.
  ///
  /// [itemCount] and [itemBuilder] must not be null.
  const DotIndicatorCarousel(
      {Key? key,
      required this.itemCount,
      required this.itemBuilder,
      this.dotColor = Colors.black,
      this.dotSize = 8,
      this.dotSpace = 8})
      : super(key: key);

  @override
  _DotIndicatorCarouselState createState() => _DotIndicatorCarouselState();
}

class _DotIndicatorCarouselState extends State<DotIndicatorCarousel> {
  /// The current selected page.
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: PageController(viewportFraction: 1, initialPage: 0),
              itemCount: widget.itemCount,
              onPageChanged: (page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              itemBuilder: (BuildContext context, int itemIndex) {
                return widget.itemBuilder(context, itemIndex);
              }),
        ),
        _buildDotIndicator()
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(
            widget.itemCount,
            (index) => Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  margin: EdgeInsets.symmetric(
                      vertical: _dotSpaceFactor * widget.dotSpace,
                      horizontal: widget.dotSpace),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedPage == index
                        ? widget.dotColor
                        : widget.dotColor.withOpacity(_dotColorFactor),
                  ),
                )));
  }
}
