import '../configs/autocomplete_grouping_config.dart';
import '../models/autocomplete_option_group.dart';

/// Creates ordered visual groups from [options] using [groupingConfig].
///
/// Grouping is presentation-only; selection semantics and option equality are
/// not changed by this transformation.
///
/// Returns an empty list when grouping is disabled (`groupBy == null`), which
/// signals the popup to render a flat list.
///
/// Returns immutable option lists in each [AutocompleteOptionGroup] to avoid
/// accidental mutation during rendering.
List<AutocompleteOptionGroup<T>> buildAutocompleteGroups<T>(
  List<T> options,
  AutocompleteGroupingConfig<T>? groupingConfig,
) {
  final groupBy = groupingConfig?.groupBy;
  if (groupBy == null) {
    return const [];
  }

  final orderedGroups = <String>[];
  final grouped = <String, List<T>>{};

  for (final option in options) {
    final name = groupBy(option);
    if (!grouped.containsKey(name)) {
      orderedGroups.add(name);
      grouped[name] = <T>[];
    }
    grouped[name]!.add(option);
  }

  if (groupingConfig?.sortGroups ?? false) {
    orderedGroups.sort(groupingConfig?.groupComparator);
  }

  return orderedGroups
      .map(
        (name) => AutocompleteOptionGroup<T>(
          name: name,
          options: List<T>.unmodifiable(grouped[name]!),
        ),
      )
      .toList(growable: false);
}
