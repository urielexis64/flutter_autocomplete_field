import 'package:flutter/widgets.dart';

/// Visual configuration for the options popup.
class AutocompletePopupConfig {
  /// Creates popup visual configuration.
  const AutocompletePopupConfig({
    this.maxHeight = 280,
    this.width,
    this.elevation = 6,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.offset = const Offset(0, 8),
    this.emptyStateHeight = 72,
    this.backgroundColor,
    this.heightAnimationDuration = const Duration(milliseconds: 180),
  });

  /// Maximum popup height constraint.
  ///
  /// Actual rendered height can be lower based on content and viewport space.
  final double maxHeight;

  /// Explicit popup width.
  ///
  /// When null, the popup follows the field width.
  final double? width;

  /// Material elevation applied to the popup surface.
  final double elevation;

  /// Internal padding applied around popup content.
  final EdgeInsetsGeometry padding;

  /// Border radius for popup clipping and decoration.
  final BorderRadius borderRadius;

  /// Position offset relative to the field anchor.
  final Offset offset;

  /// Height used for loading and empty placeholder states.
  final double emptyStateHeight;

  /// Optional explicit background color for the popup surface.
  ///
  /// When null, [ColorScheme.surface] is used.
  final Color? backgroundColor;

  /// Duration for popup height transitions.
  ///
  /// Set to [Duration.zero] to disable height animation.
  final Duration heightAnimationDuration;
}
