/// Public state passed to custom option builders.
class AutocompleteOptionState<T> {
  /// Creates state for a single popup option row.
  const AutocompleteOptionState({
    required this.option,
    required this.label,
    required this.input,
    required this.isSelected,
    required this.isDisabled,
    required this.isHighlighted,
  });

  /// Raw typed option value.
  final T option;

  /// Label derived from the field's option-label callback.
  final String label;

  /// Current user input query text.
  final String input;

  /// Whether this option is currently selected.
  final bool isSelected;

  /// Whether this option is disabled and cannot be tapped.
  final bool isDisabled;

  /// Whether this option is currently highlighted by behavior rules.
  final bool isHighlighted;
}
