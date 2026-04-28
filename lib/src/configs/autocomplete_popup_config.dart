import 'package:flutter/widgets.dart';

/// Visual configuration for the options popup.
class AutocompletePopupConfig {
  const AutocompletePopupConfig({
    this.maxHeight = 280,
    this.width,
    this.elevation = 6,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.offset = const Offset(0, 8),
    this.emptyStateHeight = 72,
  });

  final double maxHeight;
  final double? width;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Offset offset;
  final double emptyStateHeight;
}
