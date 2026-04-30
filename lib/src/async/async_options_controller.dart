import 'dart:async';

import '../configs/autocomplete_async_config.dart';

/// Snapshot emitted by [AsyncOptionsController] after each async state change.
///
/// The field view consumes these updates to synchronize loader visibility and
/// option lists while discarding stale requests.
class AsyncOptionsUpdate<T> {
  /// Creates an immutable async update payload.
  const AsyncOptionsUpdate({
    required this.options,
    required this.isLoading,
    required this.query,
  });

  /// Option list that should be rendered for [query].
  final List<T> options;

  /// Whether the request for [query] is currently in progress.
  final bool isLoading;

  /// Query text associated with this update.
  final String query;
}

/// Debounced request coordinator for async autocomplete options.
///
/// Responsibilities:
/// - debounce rapid query changes;
/// - issue async option requests;
/// - ignore stale responses using a monotonic request id;
/// - optionally retain previously loaded options while loading.
///
/// This controller does not catch exceptions thrown by
/// [AutocompleteAsyncConfig.optionsBuilder]. Callers should handle failures in
/// their own error boundary if needed.
class AsyncOptionsController<T> {
  /// Creates an async options coordinator with the given [config].
  AsyncOptionsController({
    required this.config,
    required this.onUpdate,
    this.optionsBuilderOverride,
  });

  /// Async configuration that defines debounce and loading behavior.
  final AutocompleteAsyncConfig<T> config;

  /// Callback invoked whenever loading state or options change.
  final void Function(AsyncOptionsUpdate<T> update) onUpdate;

  /// Optional query loader override used by advanced async flows.
  final Future<List<T>> Function(String query)? optionsBuilderOverride;

  Timer? _debounce;
  int _requestId = 0;

  /// Requests options for [query], applying debounce when configured.
  ///
  /// When [immediate] is `true`, the request bypasses debounce.
  /// [currentOptions] is used when
  /// [AutocompleteAsyncConfig.retainPreviousOptionsWhileLoading] is enabled.
  void request(
    String query, {
    required List<T> currentOptions,
    bool immediate = false,
  }) {
    _debounce?.cancel();
    if (immediate || config.debounceDuration == Duration.zero) {
      _run(query, currentOptions);
      return;
    }
    _debounce = Timer(config.debounceDuration, () {
      _run(query, currentOptions);
    });
  }

  /// Cancels pending debounce and invalidates in-flight responses.
  void cancel() {
    _requestId += 1;
    _debounce?.cancel();
  }

  /// Releases internal timer resources.
  void dispose() {
    _debounce?.cancel();
  }

  Future<void> _run(String query, List<T> currentOptions) async {
    final requestId = ++_requestId;
    onUpdate(
      AsyncOptionsUpdate<T>(
        options: config.retainPreviousOptionsWhileLoading ? currentOptions : [],
        isLoading: true,
        query: query,
      ),
    );

    final options = await (optionsBuilderOverride ?? config.optionsBuilder)(
      query,
    );
    if (requestId != _requestId) {
      return;
    }

    onUpdate(
      AsyncOptionsUpdate<T>(options: options, isLoading: false, query: query),
    );
  }
}
