import 'package:flutter/widgets.dart';

import '../models/autocomplete_option_state.dart';

/// Configures how selected options remain visible in the popup.
class AutocompleteSelectionConfig<T> {
  const AutocompleteSelectionConfig({
    this.keepSelectedOptionsVisible = true,
    this.showSelectionIndicator = true,
    this.selectionIndicatorBuilder,
  });

  final bool keepSelectedOptionsVisible;
  final bool showSelectionIndicator;
  final Widget Function(
          BuildContext context, AutocompleteOptionState<T> option)?
      selectionIndicatorBuilder;
}
