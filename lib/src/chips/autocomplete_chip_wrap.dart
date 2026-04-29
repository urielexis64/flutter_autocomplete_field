import 'package:flutter/material.dart';

import '../configs/autocomplete_chip_config.dart';
import '../configs/autocomplete_rendering_config.dart';
import '../fields/input_decoration_utils.dart';
import '../models/autocomplete_chip_state.dart';
import '../models/autocomplete_typedefs.dart';
import '../theme/autocomplete_defaults.dart';

class AutocompleteChipWrap<T> extends StatelessWidget {
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

  final List<T> values;
  final AutocompleteOptionLabel<T> getOptionLabel;
  final bool Function(T value) isFixed;
  final ValueChanged<T> onDelete;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final AutocompleteChipConfig<T> chipConfig;
  final AutocompleteRenderingConfig<T>? renderingConfig;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enabled && !readOnly ? focusNode.requestFocus : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chips = _buildChipWidgets(context);
          final inputWidth = _measureInputWidth(
            context,
            controller.text,
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
    final content = SizedBox(
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
                decoration: const InputDecoration(
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
        key: const ValueKey<String>('autocomplete-chip-scroll-area'),
        primary: false,
        child: content,
      ),
    );
  }

  List<Widget> _buildChipWidgets(BuildContext context) {
    final chips = values
        .map(
          (value) => AutocompleteChipState<T>(
            value: value,
            label: getOptionLabel(value),
            isFixed: isFixed(value),
            onDeleted: isFixed(value) ? null : () => onDelete(value),
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

  Widget _buildChip(BuildContext context, AutocompleteChipState<T> chip) {
    return chipConfig.chipBuilder?.call(context, chip) ??
        InputChip(
          label: Text(chip.label),
          onDeleted: chip.onDeleted,
          deleteIcon: chipConfig.deleteIcon,
        );
  }

  double _measureInputWidth(
    BuildContext context,
    String text,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? ' ' : text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

    final width =
        painter.width + AutocompleteDefaults.chipInputHorizontalPadding;
    return width.clamp(AutocompleteDefaults.chipInputMinWidth, maxWidth);
  }
}
