import '../enums/autocomplete_match_from.dart';
import '../models/autocomplete_typedefs.dart';

/// Shared client-side filtering behavior.
class AutocompleteFilterConfig<T> {
  const AutocompleteFilterConfig({
    this.filterOptions,
    this.ignoreAccents = true,
    this.ignoreCase = true,
    this.trim = true,
    this.limit,
    this.matchFrom = AutocompleteMatchFrom.anywhere,
    this.stringify,
  }) : assert(limit == null || limit >= 0);

  final List<T> Function(
    List<T> options,
    String query,
    AutocompleteOptionLabel<T> stringify,
  )? filterOptions;
  final bool ignoreAccents;
  final bool ignoreCase;
  final bool trim;
  final int? limit;
  final AutocompleteMatchFrom matchFrom;
  final AutocompleteOptionLabel<T>? stringify;
}
