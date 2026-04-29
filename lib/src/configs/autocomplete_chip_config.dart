import 'package:flutter/widgets.dart';

import '../models/autocomplete_chip_state.dart';

/// Configures chip rendering for multiple-selection modes.
class AutocompleteChipConfig<T> {
  /// Creates chip configuration for multiple-selection fields.
  ///
  /// Throws an [AssertionError] when:
  /// - [limitTags] is negative.
  /// - [maxInputAreaHeight] is non-null and not greater than zero.
  const AutocompleteChipConfig({
    this.chipBuilder,
    this.fixedValues = const [],
    this.limitTags,
    this.limitTagsWhenFocused = true,
    this.showHiddenCountChip = true,
    this.hiddenCountChipBuilder,
    this.maxInputAreaHeight,
    this.deleteIcon,
    this.spacing = 8,
    this.runSpacing = 8,
  })  : assert(limitTags == null || limitTags >= 0),
        assert(maxInputAreaHeight == null || maxInputAreaHeight > 0);

  /// Custom builder for individual selected chips.
  ///
  /// When null, a default [InputChip] is used.
  final Widget Function(BuildContext context, AutocompleteChipState<T> chip)?
      chipBuilder;

  /// Values that cannot be removed from the selection.
  ///
  /// Matching is resolved by the field equality function, not by identity.
  final List<T> fixedValues;

  /// Maximum number of chips to render before collapsing into a summary chip.
  ///
  /// Null means render all chips.
  final int? limitTags;

  /// Whether [limitTags] remains active while the input has focus.
  ///
  /// Keeping this enabled avoids large layout jumps while users type.
  final bool limitTagsWhenFocused;

  /// Whether to show a `+N` summary chip when tags are collapsed.
  final bool showHiddenCountChip;

  /// Custom builder for the hidden-count summary chip.
  ///
  /// Receives the number of hidden items.
  final Widget Function(BuildContext context, int hiddenCount)?
      hiddenCountChipBuilder;

  /// Maximum height for chip + input area before internal scrolling is used.
  ///
  /// Null allows the field to grow naturally with content.
  final double? maxInputAreaHeight;

  /// Custom icon for default chip delete actions.
  final Widget? deleteIcon;

  /// Horizontal spacing between chips and input.
  final double spacing;

  /// Vertical spacing between wrapped rows.
  final double runSpacing;
}
