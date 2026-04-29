import '../configs/autocomplete_filter_config.dart';
import '../enums/autocomplete_match_from.dart';
import '../models/autocomplete_typedefs.dart';
import '../utils/text_normalizer.dart';

/// Applies built-in option filtering behavior for the current query.
///
/// If [filterConfig.filterOptions] is provided, this function delegates to that
/// callback and only applies [AutocompleteFilterConfig.limit] afterward.
///
/// Returns a new list when filtering or limiting is applied.
List<T> applyAutocompleteFilter<T>({
  required List<T> options,
  required String query,
  required AutocompleteOptionLabel<T> getOptionLabel,
  required AutocompleteFilterConfig<T>? filterConfig,
}) {
  final config = filterConfig ?? AutocompleteFilterConfig<T>();
  final stringify = config.stringify ?? getOptionLabel;
  if (config.filterOptions != null) {
    final custom = config.filterOptions!(options, query, stringify);
    return _limit(custom, config.limit);
  }

  final normalizedQuery = normalizeAutocompleteText(
    query,
    trim: config.trim,
    ignoreCase: config.ignoreCase,
    ignoreAccents: config.ignoreAccents,
  );

  final filtered = <T>[];
  for (final option in options) {
    final label = normalizeAutocompleteText(
      stringify(option),
      trim: config.trim,
      ignoreCase: config.ignoreCase,
      ignoreAccents: config.ignoreAccents,
    );
    final matches = normalizedQuery.isEmpty
        ? true
        : switch (config.matchFrom) {
            AutocompleteMatchFrom.start => label.startsWith(normalizedQuery),
            AutocompleteMatchFrom.anywhere => label.contains(normalizedQuery),
          };
    if (matches) {
      filtered.add(option);
    }
  }
  return _limit(filtered, config.limit);
}

/// Applies result limiting when [limit] is non-null.
///
/// Returns the original [options] list when no truncation is needed.
List<T> _limit<T>(List<T> options, int? limit) {
  if (limit == null || options.length <= limit) {
    return options;
  }
  return options.take(limit).toList(growable: false);
}
