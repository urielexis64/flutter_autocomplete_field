import 'package:flutter/widgets.dart';

import '../models/autocomplete_chip_state.dart';

/// Configures chip rendering for multiple-selection modes.
class AutocompleteChipConfig<T> {
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

  final Widget Function(BuildContext context, AutocompleteChipState<T> chip)?
      chipBuilder;
  final List<T> fixedValues;
  final int? limitTags;
  final bool limitTagsWhenFocused;
  final bool showHiddenCountChip;
  final Widget Function(BuildContext context, int hiddenCount)?
      hiddenCountChipBuilder;
  final double? maxInputAreaHeight;
  final Widget? deleteIcon;
  final double spacing;
  final double runSpacing;
}
