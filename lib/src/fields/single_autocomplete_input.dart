import 'package:flutter/material.dart';

import 'input_decoration_utils.dart';

/// Single-value input renderer used by [AutocompleteFieldView].
///
/// The widget switches between:
/// - a regular [TextField] while focused or when no custom selected renderer
///   is available;
/// - an [InputDecorator]-based display when a value is selected and
///   [selectedItemBuilder] is provided.
///
/// This split keeps single mode visually consistent with multiple mode while
/// still allowing custom selected-value presentation.
class SingleAutocompleteInput<T> extends StatelessWidget {
  /// Creates the single-select input surface.
  ///
  /// The caller owns [controller] and [focusNode] lifecycles.
  const SingleAutocompleteInput({
    required this.controller,
    required this.focusNode,
    required this.decoration,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.onChanged,
    this.suffixIcon,
    this.selectedValue,
    this.selectedLabel,
    this.selectedItemBuilder,
    super.key,
  });

  /// Controller for the visible query/selection text.
  final TextEditingController controller;

  /// Focus node shared with popup open/close behavior.
  final FocusNode focusNode;

  /// Input decoration applied to both text and selected-display states.
  final InputDecoration decoration;

  /// Whether user interaction is enabled.
  final bool enabled;

  /// Whether text editing is prevented while still allowing focus.
  final bool readOnly;

  /// Whether the internal text field should request focus on mount.
  final bool autofocus;

  /// Called when query text changes.
  final ValueChanged<String> onChanged;

  /// Optional trailing controls merged into [decoration.suffixIcon].
  final Widget? suffixIcon;

  /// Currently selected value for single mode, if any.
  final T? selectedValue;

  /// Label for [selectedValue], precomputed by the parent.
  final String? selectedLabel;

  /// Optional custom selected-value builder used when unfocused.
  final Widget Function(BuildContext context, T value, String label)?
      selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    final hasCustomSelection = selectedValue != null &&
        selectedLabel != null &&
        !focusNode.hasFocus &&
        selectedItemBuilder != null;

    if (hasCustomSelection) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: enabled && !readOnly ? focusNode.requestFocus : null,
        child: InputDecorator(
          isFocused: false,
          isEmpty: false,
          decoration: mergeAutocompleteSuffixIcon(decoration, suffixIcon),
          child: selectedItemBuilder!.call(
            context,
            selectedValue as T,
            selectedLabel!,
          ),
        ),
      );
    }

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      decoration: mergeAutocompleteSuffixIcon(decoration, suffixIcon),
      onChanged: onChanged,
    );
  }
}
