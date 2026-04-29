import '../enums/autocomplete_match_from.dart';
import '../models/autocomplete_typedefs.dart';

/// Shared client-side filtering behavior.
class AutocompleteFilterConfig<T> {
  /// Creates filtering configuration for sync and async option sets.
  ///
  /// Throws an [AssertionError] when [limit] is negative.
  const AutocompleteFilterConfig({
    this.filterOptions,
    this.ignoreAccents = true,
    this.ignoreCase = true,
    this.trim = true,
    this.limit,
    this.matchFrom = AutocompleteMatchFrom.anywhere,
    this.stringify,
    this.enabled = false,
  }) : assert(limit == null || limit >= 0);

  /// Optional full custom filter callback.
  ///
  /// When provided, default matching flags such as [matchFrom], [ignoreCase],
  /// and [ignoreAccents] are bypassed.
  ///
  /// Return value side effect: the resulting list is still truncated by [limit]
  /// when [limit] is non-null.
  final List<T> Function(
    List<T> options,
    String query,
    AutocompleteOptionLabel<T> stringify,
  )? filterOptions;

  /// Whether text comparisons ignore accent marks.
  final bool ignoreAccents;

  /// Whether text comparisons are case-insensitive.
  final bool ignoreCase;

  /// Whether option labels and query text are trimmed before matching.
  final bool trim;

  /// Maximum number of items returned after filtering.
  ///
  /// Null means unbounded.
  final int? limit;

  /// Starting point for default matching.
  final AutocompleteMatchFrom matchFrom;

  /// Optional mapper used by default filtering to convert an option to text.
  ///
  /// When null, the field's `getOptionLabel` callback is used.
  final AutocompleteOptionLabel<T>? stringify;

  /// Reserved compatibility flag for explicit filtering enablement.
  ///
  /// The current filter pipeline always evaluates options through either
  /// [filterOptions] or the built-in matching implementation.
  final bool enabled;
}
