import 'dart:math';

import 'package:flutter/foundation.dart';
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
class AutocompleteChipWrap<T> extends StatefulWidget {
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
    required this.textStyle,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.chipConfig,
    required this.onTap,
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

  /// Optional text style forwarded to the embedded [TextField].
  final TextStyle? textStyle;

  /// Whether the field should render using Flutter's enabled/disabled state.
  final bool enabled;

  /// Whether the field should remain visually enabled but immutable.
  final bool readOnly;

  /// Whether the text field should request focus on mount.
  final bool autofocus;

  /// Chip layout and rendering configuration.
  final AutocompleteChipConfig<T> chipConfig;

  /// Called when the field surface is tapped.
  final VoidCallback onTap;

  /// Optional advanced rendering overrides.
  final AutocompleteRenderingConfig<T>? renderingConfig;

  /// Query changed callback from the embedded [TextField].
  final ValueChanged<String> onChanged;

  /// Optional trailing controls merged into [decoration.suffixIcon].
  final Widget? suffixIcon;

  @override
  State<AutocompleteChipWrap<T>> createState() =>
      _AutocompleteChipWrapState<T>();
}

class _AutocompleteChipWrapState<T> extends State<AutocompleteChipWrap<T>> {
  bool _expandedHiddenChips = false;

  bool get _canRequestFocus => widget.enabled && !widget.readOnly;

  bool get _canMutateValue => widget.enabled && !widget.readOnly;

  bool get _canCollapseHiddenChips {
    final limitTags = widget.chipConfig.limitTags;
    return limitTags != null &&
        widget.values.length > limitTags &&
        (widget.chipConfig.limitTagsWhenFocused || !widget.focusNode.hasFocus);
  }

  bool get _hasCollapsedHiddenChips =>
      _canCollapseHiddenChips && !_expandedHiddenChips;

  @override
  void didUpdateWidget(covariant AutocompleteChipWrap<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final valuesChanged = !listEquals(oldWidget.values, widget.values);
    final chipConfigChanged =
        oldWidget.chipConfig.limitTags != widget.chipConfig.limitTags ||
        oldWidget.chipConfig.limitTagsWhenFocused !=
            widget.chipConfig.limitTagsWhenFocused ||
        oldWidget.chipConfig.showHiddenCountChip !=
            widget.chipConfig.showHiddenCountChip;
    final shouldResetExpansion =
        valuesChanged || chipConfigChanged || !_canCollapseHiddenChips;
    if (shouldResetExpansion && _expandedHiddenChips) {
      _expandedHiddenChips = false;
    }
  }

  void _handleHiddenCountChipTap() {
    if (!_hasCollapsedHiddenChips || !widget.enabled) {
      return;
    }
    setState(() {
      _expandedHiddenChips = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _canRequestFocus ? widget.onTap : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chips = _buildChipWidgets(context);
          final inputWidth = _measureInputWidth(
            context,
            widget.controller.text,
            widget.decoration.hintText,
            constraints.maxWidth,
          );

          return InputDecorator(
            isFocused: widget.focusNode.hasFocus,
            isEmpty: widget.controller.text.isEmpty && widget.values.isEmpty,
            decoration: mergeAutocompleteSuffixIcon(
              widget.decoration,
              widget.suffixIcon,
            ),
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
    if (widget.chipConfig.layoutMode ==
        AutocompleteChipLayoutMode.horizontalScroll) {
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
        spacing: widget.chipConfig.spacing,
        runSpacing: widget.chipConfig.runSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...chips,
          if (!widget.readOnly)
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                style: widget.textStyle,
                decoration: InputDecoration(
                  hintText:
                      chips.isNotEmpty ? widget.decoration.hintText : null,
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: widget.onTap,
                onChanged: widget.onChanged,
              ),
            ),
        ],
      ),
    );

    final maxHeight = widget.chipConfig.maxInputAreaHeight;
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
      if (!widget.readOnly)
        SizedBox(
          width: inputWidth,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            style: widget.textStyle,
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onTap: widget.onTap,
            onChanged: widget.onChanged,
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
      spaced.add(SizedBox(width: widget.chipConfig.spacing));
      spaced.add(children[index]);
    }
    return spaced;
  }

  /// Builds visible chip widgets using default or custom renderers.
  List<Widget> _buildChipWidgets(BuildContext context) {
    final chips = widget.values
        .map(
          (value) => AutocompleteChipState<T>(
            value: value,
            label: widget.getOptionLabel(value),
            isFixed: widget.isFixed(value),
            onDeleted: widget.isFixed(value) || !_canMutateValue
                ? null
                : () => widget.onDelete(value),
          ),
        )
        .toList(growable: false);

    if (widget.renderingConfig?.selectedItemsBuilder case final builder?) {
      return builder(context, chips);
    }

    final shouldCollapse = _hasCollapsedHiddenChips;
    final visible = shouldCollapse
        ? chips.take(widget.chipConfig.limitTags!).toList(growable: false)
        : chips;

    final widgets =
        visible.map((chip) => _buildChip(context, chip)).toList(growable: true);

    if (shouldCollapse && widget.chipConfig.showHiddenCountChip) {
      final hiddenCount = chips.length - visible.length;
      widgets.add(
        GestureDetector(
          key: const ValueKey<String>('autocomplete-hidden-count-chip'),
          behavior: HitTestBehavior.opaque,
          onTap: _handleHiddenCountChipTap,
          child: AbsorbPointer(
            child:
                widget.chipConfig.hiddenCountChipBuilder?.call(
                  context,
                  hiddenCount,
                ) ??
                InputChip(label: Text('+$hiddenCount')),
          ),
        ),
      );
    }

    return widgets;
  }

  /// Builds one chip using [AutocompleteChipConfig.chipBuilder] when present.
  Widget _buildChip(BuildContext context, AutocompleteChipState<T> chip) {
    return widget.chipConfig.chipBuilder?.call(context, chip) ??
        InputChip(
          label: Text(chip.label),
          onDeleted: chip.onDeleted,
          deleteIcon: widget.chipConfig.deleteIcon,
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
        style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

    final width =
        painter.width + AutocompleteDefaults.chipInputHorizontalPadding;
    return min(width, maxWidth);
  }
}
