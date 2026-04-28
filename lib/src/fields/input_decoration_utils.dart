import 'package:flutter/material.dart';

InputDecoration mergeAutocompleteSuffixIcon(
  InputDecoration decoration,
  Widget? suffixIcon,
) {
  if (suffixIcon == null) {
    return decoration;
  }

  final existingSuffixIcon = decoration.suffixIcon;
  if (existingSuffixIcon == null) {
    return decoration.copyWith(suffixIcon: suffixIcon);
  }

  return decoration.copyWith(
    suffixIcon: Row(
      mainAxisSize: MainAxisSize.min,
      children: [existingSuffixIcon, suffixIcon],
    ),
  );
}
