import 'package:flutter/material.dart';

/// Merges an internal leading widget into [InputDecoration.prefix].
///
/// This keeps a user-provided prefix and a package-provided selected-value
/// adornment visible at the same time for single-field rendering.
InputDecoration mergeAutocompletePrefix(
  InputDecoration decoration,
  Widget? prefix,
) {
  if (prefix == null) {
    return decoration;
  }

  final existingPrefix = decoration.prefix;
  if (existingPrefix == null) {
    return decoration.copyWith(prefix: prefix);
  }

  return decoration.copyWith(
    prefix: Row(
      mainAxisSize: MainAxisSize.min,
      children: [existingPrefix, prefix],
    ),
  );
}

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
