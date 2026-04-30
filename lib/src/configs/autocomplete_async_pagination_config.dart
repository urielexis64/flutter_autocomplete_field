import 'package:flutter/widgets.dart';

/// Configures incremental page loading for async autocomplete options.
///
/// This configuration is optional and only applies to async constructors.
class AutocompleteAsyncPaginationConfig<T> {
  /// Creates async pagination configuration.
  ///
  /// Throws an [AssertionError] when:
  /// - [initialPage] is less than 0.
  /// - [pageSize] is less than or equal to 0.
  /// - [loadMoreTriggerOffset] is negative.
  const AutocompleteAsyncPaginationConfig({
    required this.optionsPageBuilder,
    this.initialPage = 1,
    this.pageSize = 20,
    this.hasMore,
    this.loadMoreTriggerOffset = 120,
    this.loadingMoreBuilder,
    this.endOfListBuilder,
    this.showEndOfListIndicator = false,
  })  : assert(initialPage >= 0),
        assert(pageSize > 0),
        assert(loadMoreTriggerOffset >= 0);

  /// Loads one options page for [query].
  ///
  /// [page] starts from [initialPage] and increments by one for each load.
  final Future<List<T>> Function(String query, int page, int pageSize)
      optionsPageBuilder;

  /// First page index requested for each new query.
  final int initialPage;

  /// Requested page size for [optionsPageBuilder].
  final int pageSize;

  /// Optional callback that decides whether more pages should be requested.
  ///
  /// When null, the default rule is `lastPage.length >= pageSize`.
  final bool Function(List<T> lastPage)? hasMore;

  /// Distance from list end (in logical pixels) that triggers next-page load.
  final double loadMoreTriggerOffset;

  /// Optional footer builder displayed while loading additional pages.
  final Widget Function(BuildContext context)? loadingMoreBuilder;

  /// Optional footer builder displayed when no more pages are available.
  ///
  /// This is shown only when [showEndOfListIndicator] is `true`.
  final Widget Function(BuildContext context)? endOfListBuilder;

  /// Whether to show an end-of-list footer when there are no more pages.
  final bool showEndOfListIndicator;
}
