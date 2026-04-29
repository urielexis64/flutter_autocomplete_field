import 'package:flutter/widgets.dart';

import '../models/autocomplete_chip_state.dart';
import '../models/autocomplete_option_state.dart';

/// Shared rendering hooks for popup rows and selected values.
class AutocompleteRenderingConfig<T> {
  /// Creates rendering override configuration.
  const AutocompleteRenderingConfig({
    this.optionBuilder,
    this.selectedItemBuilder,
    this.selectedItemsBuilder,
    this.groupBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
  });

  /// Custom builder for popup option rows.
  ///
  /// Return lightweight widgets when possible to keep scrolling smooth.
  final Widget Function(
    BuildContext context,
    AutocompleteOptionState<T> option,
  )? optionBuilder;

  /// Custom builder for single-select displayed value when not focused.
  final Widget Function(BuildContext context, T value, String label)?
      selectedItemBuilder;

  /// Custom builder for selected chips in multiple mode.
  ///
  /// Returning large trees here can increase rebuild cost while typing.
  final List<Widget> Function(
    BuildContext context,
    List<AutocompleteChipState<T>> items,
  )? selectedItemsBuilder;

  /// Optional wrapper for grouped content sections.
  final Widget Function(
    BuildContext context,
    String group,
    List<Widget> options,
  )? groupBuilder;

  /// Custom loading-state widget for async mode.
  final Widget Function(BuildContext context, String query)? loadingBuilder;

  /// Custom empty-state widget when no options are visible.
  final Widget Function(BuildContext context, String query)? emptyBuilder;
}
