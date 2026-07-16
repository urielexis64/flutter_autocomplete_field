import 'dart:math';

import 'package:flutter/material.dart';

import '../configs/autocomplete_chip_config.dart';
import '../configs/autocomplete_rendering_config.dart';
import '../enums/autocomplete_chip_layout_mode.dart';
import '../fields/input_decoration_utils.dart';
import '../models/autocomplete_chip_state.dart';
import '../models/autocomplete_typedefs.dart';
import '../theme/autocomplete_defaults.dart';

/// Chip-based input surface used by multiple-selection modes.
///
/// Layout model:
/// - [InputDecorator] is the outer form shell.
/// - A [Wrap] inside the decorator renders selected chips and a borderless
///   [TextField].
///
/// This structure keeps the field mobile-friendly: it can grow vertically
/// without overflow, supports tap-anywhere focus, and keeps label floating
/// semantics aligned with [InputDecorator.isFocused]/`isEmpty`.
class AutocompleteChipWrap<T> extends StatelessWidget {
  /// Creates a chip-wrapped multiple-selection input.
  ///
  /// The caller owns [controller] and [focusNode] lifecycles.
  const AutocompleteChipWrap({
    required this.values,
    required this.getOptionLabel,
    required this.isFixed,
    required this.onDelete,
    required this.controller,
    required this.focusNode,
    required this.decoration,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.chipConfig,
    required this.onChanged,
    this.suffixIcon,
    this.renderingConfig,
    super.key,
  });

  /// Selected values rendered as chips.
  final List<T> values;

  /// Label resolver for selected values.
  final AutocompleteOptionLabel<T> getOptionLabel;

  /// Returns `true` when a chip is fixed and cannot be removed.
  final bool Function(T value) isFixed;

  /// Called when a removable chip delete action is triggered.
  final ValueChanged<T> onDelete;

  /// Query text controller.
  final TextEditingController controller;

  /// Focus node for the embedded text field.
  final FocusNode focusNode;

  /// Decoration applied by the outer [InputDecorator].
  final InputDecoration decoration;

  /// Whether the field should render using Flutter's enabled/disabled state.
  final bool enabled;

  /// Whether the field should remain visually enabled but immutable.
  final bool readOnly;

  /// Whether the text field should request focus on mount.
  final bool autofocus;

  /// Chip layout and rendering configuration.
  final AutocompleteChipConfig<T> chipConfig;

  /// Optional advanced rendering overrides.
  final AutocompleteRenderingConfig<T>? renderingConfig;

  /// Query changed callback from the embedded [TextField].
  final ValueChanged<String> onChanged;

  /// Optional trailing controls merged into [decoration.suffixIcon].
  final Widget? suffixIcon;

  bool get _canRequestFocus => enabled && !readOnly;

  bool get _canMutateValue => enabled && !readOnly;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _canRequestFocus ? focusNode.requestFocus : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chips = _buildChipWidgets(context);
          final inputWidth = _measureInputWidth(
            context,
            controller.text,
            decoration.hintText,
            constraints.maxWidth,
          );

          return InputDecorator(
            isFocused: focusNode.hasFocus,
            isEmpty: controller.text.isEmpty && values.isEmpty,
            decoration: mergeAutocompleteSuffixIcon(decoration, suffixIcon),
            child: _buildChipArea(
              constraints: constraints,
              chips: chips,
              inputWidth: inputWidth,
            ),
          );
        },
      ),
    );
  }

  Widget _buildChipArea({
    required BoxConstraints constraints,
    required List<Widget> chips,
    required double inputWidth,
  }) {
    if (chipConfig.layoutMode == AutocompleteChipLayoutMode.horizontalScroll) {
      return _buildHorizontalChipArea(
        constraints: constraints,
        chips: chips,
        inputWidth: inputWidth,
      );
    }

    return _buildWrapChipArea(
      constraints: constraints,
      chips: chips,
      inputWidth: inputWidth,
    );
  }

  Widget _buildWrapChipArea({
    required BoxConstraints constraints,
    required List<Widget> chips,
    required double inputWidth,
  }) {
    final content = SizedBox(
      key: const ValueKey<String>('autocomplete-chip-layout-wrap'),
      width: constraints.maxWidth,
      child: Wrap(
        spacing: chipConfig.spacing,
        runSpacing: chipConfig.runSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...chips,
          if (!readOnly)
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                autofocus: autofocus,
                decoration: InputDecoration(
                  hintText: chips.isNotEmpty ? decoration.hintText : null,
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
              ),
            ),
        ],
      ),
    );

    final maxHeight = chipConfig.maxInputAreaHeight;
    if (maxHeight == null) {
      return content;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        reverse: true,
        key: const ValueKey<String>('autocomplete-chip-scroll-area'),
        primary: false,
        child: content,
      ),
    );
  }

  Widget _buildHorizontalChipArea({
    required BoxConstraints constraints,
    required List<Widget> chips,
    required double inputWidth,
  }) {
    final children = <Widget>[
      ..._withHorizontalSpacing(chips),
      if (!readOnly)
        SizedBox(
          width: inputWidth,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            autofocus: autofocus,
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
          ),
        ),
    ];

    return SingleChildScrollView(
      key: const ValueKey<String>('autocomplete-chip-layout-horizontal'),
      primary: false,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: Row(children: children),
      ),
    );
  }

  List<Widget> _withHorizontalSpacing(List<Widget> children) {
    if (children.isEmpty) {
      return const [];
    }
    final spaced = <Widget>[children.first];
    for (var index = 1; index < children.length; index += 1) {
      spaced.add(SizedBox(width: chipConfig.spacing));
      spaced.add(children[index]);
    }
    return spaced;
  }

  /// Builds visible chip widgets using default or custom renderers.
  List<Widget> _buildChipWidgets(BuildContext context) {
    final chips = values
        .map(
          (value) => AutocompleteChipState<T>(
            value: value,
            label: getOptionLabel(value),
            isFixed: isFixed(value),
            onDeleted: isFixed(value) || !_canMutateValue
                ? null
                : () => onDelete(value),
          ),
        )
        .toList(growable: false);

    if (renderingConfig?.selectedItemsBuilder case final builder?) {
      return builder(context, chips);
    }

    final shouldCollapse = chipConfig.limitTags != null &&
        chips.length > chipConfig.limitTags! &&
        (chipConfig.limitTagsWhenFocused || !focusNode.hasFocus);
    final visible = shouldCollapse
        ? chips.take(chipConfig.limitTags!).toList(growable: false)
        : chips;

    final widgets =
        visible.map((chip) => _buildChip(context, chip)).toList(growable: true);

    if (shouldCollapse && chipConfig.showHiddenCountChip) {
      final hiddenCount = chips.length - visible.length;
      widgets.add(
        chipConfig.hiddenCountChipBuilder?.call(context, hiddenCount) ??
            InputChip(label: Text('+$hiddenCount')),
      );
    }

    return widgets;
  }

  /// Builds one chip using [AutocompleteChipConfig.chipBuilder] when present.
  Widget _buildChip(BuildContext context, AutocompleteChipState<T> chip) {
    return chipConfig.chipBuilder?.call(context, chip) ??
        InputChip(
          label: Text(chip.label),
          onDeleted: chip.onDeleted,
          deleteIcon: chipConfig.deleteIcon,
        );
  }

  /// Measures text width to keep the inline input usable inside the wrap.
  ///
  /// Returns a clamped width between package defaults and [maxWidth].
  double _measureInputWidth(
    BuildContext context,
    String text,
    String? hintText,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? (hintText ?? ' ') : text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

    final width =
        painter.width + AutocompleteDefaults.chipInputHorizontalPadding;
    return min(width, maxWidth);
  }
}
