/// A convenience option model for simple object-based autocomplete values.
///
/// The core widget is generic and does not require this class. It is provided
/// for examples and apps that want stable keys, labels, and disabled flags
/// without defining their own model.
class AutocompleteOption<T> {
  /// Creates a labeled option wrapping [value].
  const AutocompleteOption({
    required this.value,
    required this.label,
    Object? key,
    this.disabled = false,
  }) : key = key ?? value;

  /// Application value represented by the option.
  final T value;

  /// User-visible label.
  final String label;

  /// Stable identity used when labels are duplicated.
  final Object? key;

  /// Whether the option is visible but not selectable.
  final bool disabled;

  @override
  String toString() => label;
}
