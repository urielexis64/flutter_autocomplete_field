import 'package:flutter/widgets.dart';

/// Fixed-height delegate used to pin popup group headers.
///
/// This delegate intentionally keeps [minExtent] and [maxExtent] equal so each
/// header has stable geometry during list scrolling.
class GroupHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Creates a sliver delegate for a pinned group header.
  GroupHeaderDelegate({required this.child, required this.extent});

  /// Header content to render.
  final Widget child;

  /// Fixed header height in logical pixels.
  final double extent;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(GroupHeaderDelegate oldDelegate) {
    return child != oldDelegate.child || extent != oldDelegate.extent;
  }
}
