import 'dart:async';

/// Runs the latest callback after a quiet period.
///
/// This is useful for search-as-you-type examples where MUI recommends
/// throttling or debouncing network requests when filtering is performed on
/// the server.
class AutocompleteDebouncer {
  /// Creates a debouncer with the given [duration].
  AutocompleteDebouncer(this.duration);

  /// Quiet period before the callback is executed.
  final Duration duration;

  Timer? _timer;

  /// Schedules [callback], replacing any callback that has not run yet.
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Cancels the pending callback, if any.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Cancels timers held by this debouncer.
  void dispose() {
    cancel();
  }
}
