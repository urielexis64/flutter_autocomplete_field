import 'autocomplete_types.dart';
import 'utils/diacritics.dart';

/// Default label extraction used when callers do not provide one.
String defaultAutocompleteOptionLabel<T>(T option) {
  if (option == null) {
    return '';
  }
  try {
    final dynamic dynamicOption = option;
    final Object? label = dynamicOption.label as Object?;
    if (label != null) {
      return label.toString();
    }
  } on Object {
    // Fall back to toString for plain strings, numbers, and custom objects.
  }
  return option.toString();
}

/// Creates a filter callback similar to MUI's `createFilterOptions`.
///
/// It supports the same core knobs documented by MUI: ignoring accents,
/// ignoring case, limiting results, matching from the start or anywhere,
/// custom stringification, and optional trimming of the input.
AutocompleteFilterCallback<T> createAutocompleteFilter<T>({
  bool ignoreAccents = true,
  bool ignoreCase = true,
  int? limit,
  AutocompleteFilterMatchFrom matchFrom = AutocompleteFilterMatchFrom.any,
  String Function(T option)? stringify,
  bool trim = false,
}) {
  return (List<T> options, AutocompleteFilterState<T> state) {
    var query = trim ? state.inputValue.trim() : state.inputValue;
    if (ignoreAccents) {
      query = stripDiacritics(query);
    }
    if (ignoreCase) {
      query = query.toLowerCase();
    }

    final matches = <T>[];
    for (final option in options) {
      var candidate = stringify?.call(option) ?? state.getOptionLabel(option);
      if (ignoreAccents) {
        candidate = stripDiacritics(candidate);
      }
      if (ignoreCase) {
        candidate = candidate.toLowerCase();
      }

      final matched = switch (matchFrom) {
        AutocompleteFilterMatchFrom.any => candidate.contains(query),
        AutocompleteFilterMatchFrom.start => candidate.startsWith(query),
      };

      if (matched) {
        matches.add(option);
        if (limit != null && matches.length >= limit) {
          break;
        }
      }
    }
    return matches;
  };
}

/// Returns the options unchanged.
///
/// Use this for server-side filtering, matching MUI's guidance to override
/// `filterOptions` with an identity function when the server already filtered
/// search-as-you-type results.
List<T> identityAutocompleteFilter<T>(
  List<T> options,
  AutocompleteFilterState<T> state,
) {
  return options;
}
