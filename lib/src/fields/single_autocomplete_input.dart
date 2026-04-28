import 'package:flutter/material.dart';

import 'input_decoration_utils.dart';

class SingleAutocompleteInput<T> extends StatelessWidget {
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

  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;
  final T? selectedValue;
  final String? selectedLabel;
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
