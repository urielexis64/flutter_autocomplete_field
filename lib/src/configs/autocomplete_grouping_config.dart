import 'package:flutter/widgets.dart';

/// Visual grouping rules for the popup.
///
/// Grouping never changes selection, equality, or the underlying option list.
/// It only changes how options are rendered in the popup.
class AutocompleteGroupingConfig<T> {
  const AutocompleteGroupingConfig({
    this.groupBy,
    this.groupHeaderBuilder,
    this.groupComparator,
    this.sortGroups = false,
    this.stickyHeaders = false,
  });

  final String Function(T option)? groupBy;
  final Widget Function(BuildContext context, String group)? groupHeaderBuilder;
  final int Function(String a, String b)? groupComparator;
  final bool sortGroups;
  final bool stickyHeaders;
}
