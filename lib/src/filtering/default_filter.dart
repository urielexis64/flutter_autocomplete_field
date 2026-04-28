import '../configs/autocomplete_filter_config.dart';
import '../enums/autocomplete_match_from.dart';
import '../models/autocomplete_typedefs.dart';
import '../utils/text_normalizer.dart';

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

List<T> _limit<T>(List<T> options, int? limit) {
  if (limit == null || options.length <= limit) {
    return options;
  }
  return options.take(limit).toList(growable: false);
}
