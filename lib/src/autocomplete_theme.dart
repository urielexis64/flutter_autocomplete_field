import 'dart:ui';

import 'package:flutter/material.dart';

import 'autocomplete_types.dart';

/// Theme extension for [AutocompleteField] styling.
class AutocompleteThemeData extends ThemeExtension<AutocompleteThemeData> {
  /// Creates theme data for autocomplete widgets.
  const AutocompleteThemeData({
    this.popupColor,
    this.optionHighlightColor,
    this.optionSelectedColor,
    this.groupHeaderColor,
    this.chipColor,
    this.optionTextStyle,
    this.groupHeaderTextStyle,
    this.popupElevation = 4,
    this.popupBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.optionHeight = 48,
    this.smallOptionHeight = 40,
    this.chipSpacing = 6,
  });

  /// Popup material color.
  final Color? popupColor;

  /// Background color for the highlighted option.
  final Color? optionHighlightColor;

  /// Background color for selected options.
  final Color? optionSelectedColor;

  /// Background color for group headers.
  final Color? groupHeaderColor;

  /// Background color for selected chips.
  final Color? chipColor;

  /// Text style for option labels.
  final TextStyle? optionTextStyle;

  /// Text style for group headers.
  final TextStyle? groupHeaderTextStyle;

  /// Material elevation for the popup.
  final double popupElevation;

  /// Border radius for the popup material.
  final BorderRadius popupBorderRadius;

  /// Option row height for [AutocompleteSize.medium].
  final double optionHeight;

  /// Option row height for [AutocompleteSize.small].
  final double smallOptionHeight;

  /// Spacing between selected chips.
  final double chipSpacing;

  /// Resolves autocomplete theme data from the ambient Material [theme].
  static AutocompleteThemeData resolve(
    ThemeData theme,
    AutocompleteThemeData? localTheme,
  ) {
    final extension = theme.extension<AutocompleteThemeData>();
    return const AutocompleteThemeData()
        .merge(extension)
        .merge(localTheme)
        .withMaterialDefaults(theme);
  }

  /// Returns a copy with Material defaults filled in.
  AutocompleteThemeData withMaterialDefaults(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return copyWith(
      popupColor: popupColor ?? theme.cardColor,
      optionHighlightColor:
          optionHighlightColor ?? colorScheme.primary.withValues(alpha: 0.08),
      optionSelectedColor:
          optionSelectedColor ?? colorScheme.primary.withValues(alpha: 0.12),
      groupHeaderColor: groupHeaderColor ?? colorScheme.surfaceContainerHighest,
      chipColor: chipColor ?? colorScheme.secondaryContainer,
      optionTextStyle: optionTextStyle ?? theme.textTheme.bodyMedium,
      groupHeaderTextStyle:
          groupHeaderTextStyle ??
          theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// Returns a copy with selected fields replaced.
  @override
  AutocompleteThemeData copyWith({
    Color? popupColor,
    Color? optionHighlightColor,
    Color? optionSelectedColor,
    Color? groupHeaderColor,
    Color? chipColor,
    TextStyle? optionTextStyle,
    TextStyle? groupHeaderTextStyle,
    double? popupElevation,
    BorderRadius? popupBorderRadius,
    double? optionHeight,
    double? smallOptionHeight,
    double? chipSpacing,
  }) {
    return AutocompleteThemeData(
      popupColor: popupColor ?? this.popupColor,
      optionHighlightColor: optionHighlightColor ?? this.optionHighlightColor,
      optionSelectedColor: optionSelectedColor ?? this.optionSelectedColor,
      groupHeaderColor: groupHeaderColor ?? this.groupHeaderColor,
      chipColor: chipColor ?? this.chipColor,
      optionTextStyle: optionTextStyle ?? this.optionTextStyle,
      groupHeaderTextStyle: groupHeaderTextStyle ?? this.groupHeaderTextStyle,
      popupElevation: popupElevation ?? this.popupElevation,
      popupBorderRadius: popupBorderRadius ?? this.popupBorderRadius,
      optionHeight: optionHeight ?? this.optionHeight,
      smallOptionHeight: smallOptionHeight ?? this.smallOptionHeight,
      chipSpacing: chipSpacing ?? this.chipSpacing,
    );
  }

  /// Merges [other] over this theme.
  AutocompleteThemeData merge(AutocompleteThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      popupColor: other.popupColor,
      optionHighlightColor: other.optionHighlightColor,
      optionSelectedColor: other.optionSelectedColor,
      groupHeaderColor: other.groupHeaderColor,
      chipColor: other.chipColor,
      optionTextStyle: other.optionTextStyle,
      groupHeaderTextStyle: other.groupHeaderTextStyle,
      popupElevation: other.popupElevation,
      popupBorderRadius: other.popupBorderRadius,
      optionHeight: other.optionHeight,
      smallOptionHeight: other.smallOptionHeight,
      chipSpacing: other.chipSpacing,
    );
  }

  @override
  AutocompleteThemeData lerp(
    ThemeExtension<AutocompleteThemeData>? other,
    double t,
  ) {
    if (other is! AutocompleteThemeData) {
      return this;
    }
    return AutocompleteThemeData(
      popupColor: Color.lerp(popupColor, other.popupColor, t),
      optionHighlightColor: Color.lerp(
        optionHighlightColor,
        other.optionHighlightColor,
        t,
      ),
      optionSelectedColor: Color.lerp(
        optionSelectedColor,
        other.optionSelectedColor,
        t,
      ),
      groupHeaderColor: Color.lerp(groupHeaderColor, other.groupHeaderColor, t),
      chipColor: Color.lerp(chipColor, other.chipColor, t),
      optionTextStyle: TextStyle.lerp(
        optionTextStyle,
        other.optionTextStyle,
        t,
      ),
      groupHeaderTextStyle: TextStyle.lerp(
        groupHeaderTextStyle,
        other.groupHeaderTextStyle,
        t,
      ),
      popupElevation: lerpDouble(popupElevation, other.popupElevation, t)!,
      popupBorderRadius: BorderRadius.lerp(
        popupBorderRadius,
        other.popupBorderRadius,
        t,
      )!,
      optionHeight: lerpDouble(optionHeight, other.optionHeight, t)!,
      smallOptionHeight: lerpDouble(
        smallOptionHeight,
        other.smallOptionHeight,
        t,
      )!,
      chipSpacing: lerpDouble(chipSpacing, other.chipSpacing, t)!,
    );
  }

  /// Returns the row height for [size].
  double rowHeightFor(AutocompleteSize size) {
    return switch (size) {
      AutocompleteSize.medium => optionHeight,
      AutocompleteSize.small => smallOptionHeight,
    };
  }
}
