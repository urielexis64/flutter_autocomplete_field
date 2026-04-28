import 'package:flutter/widgets.dart';

import '../models/autocomplete_chip_state.dart';
import '../models/autocomplete_option_state.dart';

/// Shared rendering hooks for popup rows and selected values.
class AutocompleteRenderingConfig<T> {
  const AutocompleteRenderingConfig({
    this.optionBuilder,
    this.selectedItemBuilder,
    this.selectedItemsBuilder,
    this.groupBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
  });

  final Widget Function(
    BuildContext context,
    AutocompleteOptionState<T> option,
  )? optionBuilder;
  final Widget Function(BuildContext context, T value, String label)?
      selectedItemBuilder;
  final List<Widget> Function(
    BuildContext context,
    List<AutocompleteChipState<T>> items,
  )? selectedItemsBuilder;
  final Widget Function(
    BuildContext context,
    String group,
    List<Widget> options,
  )? groupBuilder;
  final Widget Function(BuildContext context, String query)? loadingBuilder;
  final Widget Function(BuildContext context, String query)? emptyBuilder;
}
