import '../autocomplete_types.dart';

/// A group of autocomplete options.
///
/// Groups are coalesced by their [group] value across the whole option list,
/// preserving the first time each group appears. This avoids duplicate headers
/// when options are not pre-sorted by the grouping dimension.
class AutocompleteOptionGroup<T> {
  /// Creates a group named [group] containing [options].
  const AutocompleteOptionGroup({required this.group, required this.options});

  /// Header text for the group.
  final String group;

  /// Options belonging to the group.
  final List<T> options;
}

/// An option with its original index before grouped visual ordering.
class AutocompleteIndexedOption<T> {
  /// Creates an indexed option entry.
  const AutocompleteIndexedOption({required this.option, required this.index});

  /// Option value.
  final T option;

  /// Original index in the filtered option list.
  final int index;
}

/// A group of indexed autocomplete options.
class AutocompleteIndexedOptionGroup<T> {
  /// Creates a group named [group] containing indexed [options].
  const AutocompleteIndexedOptionGroup({
    required this.group,
    required this.options,
  });

  /// Header text for the group.
  final String group;

  /// Options belonging to the group with their original filtered indexes.
  final List<AutocompleteIndexedOption<T>> options;
}

/// Groups [options] by [groupBy], coalescing duplicate group values.
List<AutocompleteOptionGroup<T>> groupAutocompleteOptions<T>(
  List<T> options,
  AutocompleteOptionGroupBy<T> groupBy,
) {
  return groupAutocompleteOptionsWithIndexes(options, groupBy)
      .map(
        (group) => AutocompleteOptionGroup<T>(
          group: group.group,
          options: List<T>.unmodifiable(
            group.options.map((entry) => entry.option),
          ),
        ),
      )
      .toList(growable: false);
}

/// Groups [options] by [groupBy] while preserving original option indexes.
List<AutocompleteIndexedOptionGroup<T>> groupAutocompleteOptionsWithIndexes<T>(
  List<T> options,
  AutocompleteOptionGroupBy<T> groupBy,
) {
  final groupedOptions = <String, List<AutocompleteIndexedOption<T>>>{};

  for (var index = 0; index < options.length; index++) {
    final option = options[index];
    final group = groupBy(option);
    groupedOptions
        .putIfAbsent(group, () => <AutocompleteIndexedOption<T>>[])
        .add(AutocompleteIndexedOption<T>(option: option, index: index));
  }

  return groupedOptions.entries
      .map(
        (entry) => AutocompleteIndexedOptionGroup<T>(
          group: entry.key,
          options: List<AutocompleteIndexedOption<T>>.unmodifiable(entry.value),
        ),
      )
      .toList(growable: false);
}
