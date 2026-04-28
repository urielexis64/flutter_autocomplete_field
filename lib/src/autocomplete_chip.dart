import 'package:flutter/material.dart';

import 'autocomplete_types.dart';

/// Default Material chip used for selected autocomplete values.
class AutocompleteChip extends StatelessWidget {
  /// Creates an autocomplete selected-value chip.
  const AutocompleteChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.disabled = false,
    this.size = AutocompleteSize.medium,
    this.backgroundColor,
    this.textStyle,
    this.deleteIcon,
    this.shape,
    this.side,
    this.labelPadding,
    this.elevation,
    this.labelMaxWidth,
  });

  /// Text displayed inside the chip.
  final String label;

  /// Called when the user deletes the chip.
  final VoidCallback? onDeleted;

  /// Whether the chip is fixed and cannot be removed.
  final bool disabled;

  /// Visual density of the chip.
  final AutocompleteSize size;

  /// Optional chip background color.
  final Color? backgroundColor;

  /// Optional text style for the chip label.
  final TextStyle? textStyle;

  /// Optional delete icon.
  final Widget? deleteIcon;

  /// Optional chip shape.
  final OutlinedBorder? shape;

  /// Optional chip border side.
  final BorderSide? side;

  /// Optional padding around the label.
  final EdgeInsetsGeometry? labelPadding;

  /// Optional Material elevation for the chip.
  final double? elevation;

  /// Optional maximum width for the chip label.
  final double? labelMaxWidth;

  @override
  Widget build(BuildContext context) {
    final deleteLabel = disabled ? null : 'Remove $label';
    final labelWidget = Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    return Semantics(
      label: label,
      button: !disabled,
      enabled: !disabled,
      hint: deleteLabel,
      child: InputChip(
        label: labelMaxWidth == null
            ? labelWidget
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: labelMaxWidth!),
                child: labelWidget,
              ),
        visualDensity: size == AutocompleteSize.small
            ? VisualDensity.compact
            : VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: backgroundColor,
        deleteIcon: deleteIcon,
        shape: shape,
        side: side,
        labelPadding: labelPadding,
        elevation: elevation,
        onDeleted: disabled ? null : onDeleted,
      ),
    );
  }
}
