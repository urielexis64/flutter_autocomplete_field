import 'package:flutter/widgets.dart';

/// Public state passed to custom chip builders.
class AutocompleteChipState<T> {
  const AutocompleteChipState({
    required this.value,
    required this.label,
    required this.isFixed,
    required this.onDeleted,
  });

  final T value;
  final String label;
  final bool isFixed;
  final VoidCallback? onDeleted;
}
