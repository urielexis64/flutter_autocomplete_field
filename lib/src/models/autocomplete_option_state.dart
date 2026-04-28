/// Public state passed to custom option builders.
class AutocompleteOptionState<T> {
  const AutocompleteOptionState({
    required this.option,
    required this.label,
    required this.input,
    required this.isSelected,
    required this.isDisabled,
    required this.isHighlighted,
  });

  final T option;
  final String label;
  final String input;
  final bool isSelected;
  final bool isDisabled;
  final bool isHighlighted;
}
