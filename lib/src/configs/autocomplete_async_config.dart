/// Configures async option loading.
class AutocompleteAsyncConfig<T> {
  const AutocompleteAsyncConfig({
    required this.optionsBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.minQueryLength = 0,
    this.loadOnFocus = false,
    this.retainPreviousOptionsWhileLoading = true,
  }) : assert(minQueryLength >= 0);

  final Future<List<T>> Function(String query) optionsBuilder;
  final Duration debounceDuration;
  final int minQueryLength;
  final bool loadOnFocus;
  final bool retainPreviousOptionsWhileLoading;
}
