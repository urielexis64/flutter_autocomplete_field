import 'package:flutter/widgets.dart';

/// {@template autocomplete.groupingVisualOnly}
/// Visual grouping rules for the popup.
///
/// Grouping never changes selection, equality, or the underlying option list.
/// It only changes how options are rendered in the popup.
/// {@endtemplate}
class AutocompleteGroupingConfig<T> {
  /// Creates grouping configuration shared by all field modes.
  const AutocompleteGroupingConfig({
    this.groupBy,
    this.groupHeaderBuilder,
    this.groupComparator,
    this.sortGroups = false,
    this.stickyHeaders = true,
  });

  /// Maps each option to a group label.
  ///
  /// When null, the popup is rendered as a flat ungrouped list.
  final String Function(T option)? groupBy;

  /// Custom builder for group header rows.
  ///
  /// When null, the popup renders a default Material header style.
  final Widget Function(BuildContext context, String group)? groupHeaderBuilder;

  /// Optional comparator used when [sortGroups] is enabled.
  final int Function(String a, String b)? groupComparator;

  /// Whether group labels should be sorted before rendering.
  ///
  /// When `false`, groups keep insertion order from the option list.
  final bool sortGroups;

  /// Whether group headers should stay pinned while scrolling options.
  ///
  /// Defaults to `true`.
  final bool stickyHeaders;
}
