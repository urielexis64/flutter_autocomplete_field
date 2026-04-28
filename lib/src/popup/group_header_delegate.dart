import 'package:flutter/widgets.dart';

class GroupHeaderDelegate extends SliverPersistentHeaderDelegate {
  GroupHeaderDelegate({required this.child, required this.extent});

  final Widget child;
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
