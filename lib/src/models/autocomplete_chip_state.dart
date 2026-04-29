import 'package:flutter/widgets.dart';

/// Public state passed to custom chip builders.
class AutocompleteChipState<T> {
  /// Creates state for a selected chip.
  const AutocompleteChipState({
    required this.value,
    required this.label,
    required this.isFixed,
    required this.onDeleted,
  });

  /// Raw typed selected value.
  final T value;

  /// Display label for the selected value.
  final String label;

  /// Whether this chip is fixed and non-removable.
  final bool isFixed;

  /// Callback used by default chip builders to remove the value.
  ///
  /// Null when the chip is fixed.
  final VoidCallback? onDeleted;
}
