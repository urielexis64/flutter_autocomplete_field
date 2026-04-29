import 'package:flutter/material.dart';

/// Merges an internal trailing control container into [InputDecoration].
///
/// This helper keeps custom user-provided suffix widgets and package-provided
/// actions (for example clear and dropdown buttons) visible at the same time.
///
/// The merge strategy is:
/// 1. Return [decoration] unchanged when [suffixIcon] is `null`.
/// 2. Use [suffixIcon] directly when [decoration.suffixIcon] is `null`.
/// 3. Otherwise render both controls inside a compact [Row].
///
/// Returns an updated [InputDecoration] with a combined `suffixIcon`.
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
      children: [suffixIcon, existingSuffixIcon],
    ),
  );
}
