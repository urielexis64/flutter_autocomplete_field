/// Represents a rendered option group in the popup.
///
/// Grouping is presentation-only; this model does not change option identity
/// or selection behavior.
class AutocompleteOptionGroup<T> {
  /// Creates an immutable option group model.
  const AutocompleteOptionGroup({required this.name, required this.options});

  /// Group label shown in the popup header.
  final String name;

  /// Options assigned to this group in render order.
  final List<T> options;
}
