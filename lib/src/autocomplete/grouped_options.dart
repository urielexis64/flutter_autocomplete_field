import '../configs/autocomplete_grouping_config.dart';
import '../models/autocomplete_option_group.dart';

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
