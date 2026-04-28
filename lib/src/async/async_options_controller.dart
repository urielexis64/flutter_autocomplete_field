import 'dart:async';

import '../configs/autocomplete_async_config.dart';

class AsyncOptionsUpdate<T> {
  const AsyncOptionsUpdate({
    required this.options,
    required this.isLoading,
    required this.query,
  });

  final List<T> options;
  final bool isLoading;
  final String query;
}

class AsyncOptionsController<T> {
  AsyncOptionsController({required this.config, required this.onUpdate});

  final AutocompleteAsyncConfig<T> config;
  final void Function(AsyncOptionsUpdate<T> update) onUpdate;

  Timer? _debounce;
  int _requestId = 0;

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

  void cancel() {
    _requestId += 1;
    _debounce?.cancel();
  }

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

    final options = await config.optionsBuilder(query);
    if (requestId != _requestId) {
      return;
    }

    onUpdate(
      AsyncOptionsUpdate<T>(options: options, isLoading: false, query: query),
    );
  }
}
