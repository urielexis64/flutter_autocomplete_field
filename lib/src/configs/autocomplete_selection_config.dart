import 'package:flutter/widgets.dart';

import '../models/autocomplete_option_state.dart';

/// Configures how selected options remain visible in the popup.
class AutocompleteSelectionConfig<T> {
  /// Creates selection rendering configuration.
  const AutocompleteSelectionConfig({
    this.keepSelectedOptionsVisible = true,
    this.showSelectionIndicator = true,
    this.selectionIndicatorBuilder,
  });

  /// Whether selected options remain in the popup list.
  ///
  /// When `false`, selected items are filtered out from visible options.
  final bool keepSelectedOptionsVisible;

  /// Whether selected rows render a visual indicator.
  final bool showSelectionIndicator;

  /// Optional custom widget for selected-row indicators.
  ///
  /// Receives the full option state for contextual rendering.
  final Widget Function(
          BuildContext context, AutocompleteOptionState<T> option)?
      selectionIndicatorBuilder;
}
