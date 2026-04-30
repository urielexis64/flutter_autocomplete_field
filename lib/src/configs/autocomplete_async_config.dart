import 'autocomplete_async_pagination_config.dart';

/// Configures asynchronous option loading for async autocomplete constructors.
///
/// Use this configuration when options come from a backend, local database, or
/// another asynchronous source.
///
/// Example:
/// ```dart
/// AutocompleteAsyncConfig<String>(
///   optionsBuilder: cityRepository.search,
///   debounceDuration: const Duration(milliseconds: 250),
///   minQueryLength: 2,
/// )
/// ```
class AutocompleteAsyncConfig<T> {
  /// Creates an async configuration.
  ///
  /// Throws an [AssertionError] when [minQueryLength] is negative.
  const AutocompleteAsyncConfig({
    required this.optionsBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.minQueryLength = 0,
    this.loadOnFocus = false,
    this.retainPreviousOptionsWhileLoading = true,
    this.paginationConfig,
  }) : assert(minQueryLength >= 0);

  /// Asynchronously loads options for a query string.
  ///
  /// The callback is expected to be side-effect free from the UI perspective.
  /// If the returned future fails, the caller does not catch it internally.
  /// Handle expected failures inside this callback and return a safe fallback
  /// list when needed.
  final Future<List<T>> Function(String query) optionsBuilder;

  /// Delay applied before issuing [optionsBuilder] for non-immediate requests.
  ///
  /// Use `Duration.zero` to disable debouncing.
  final Duration debounceDuration;

  /// Minimum query length required before loading options.
  ///
  /// A value of `0` allows loading for empty query values.
  final int minQueryLength;

  /// Whether to trigger an initial load when the field gains focus.
  ///
  /// This is useful for "show suggestions on focus" experiences.
  final bool loadOnFocus;

  /// Whether previous options should remain visible while a new request loads.
  ///
  /// When `false`, options are cleared while loading to avoid showing stale
  /// results from an older query.
  final bool retainPreviousOptionsWhileLoading;

  /// Optional pagination behavior for incremental async loading.
  ///
  /// When null, async options are loaded as a single complete list.
  final AutocompleteAsyncPaginationConfig<T>? paginationConfig;
}
