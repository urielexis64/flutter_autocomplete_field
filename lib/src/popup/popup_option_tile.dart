import 'package:flutter/material.dart';

import '../configs/autocomplete_selection_config.dart';
import '../models/autocomplete_option_state.dart';

class PopupOptionTile<T> extends StatelessWidget {
  const PopupOptionTile({
    required this.state,
    required this.onTap,
    required this.builder,
    required this.selectionConfig,
    this.tileKey,
    super.key,
  });

  final AutocompleteOptionState<T> state;
  final VoidCallback? onTap;
  final Widget Function(
    BuildContext context,
    AutocompleteOptionState<T> option,
  )? builder;
  final AutocompleteSelectionConfig<T> selectionConfig;
  final Key? tileKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = state.isHighlighted
        ? theme.colorScheme.surfaceContainerHighest
        : Colors.transparent;

    return Material(
      color: background,
      child: InkWell(
        key: tileKey,
        onTap: state.isDisabled ? null : onTap,
        child: builder?.call(context, state) ??
            _DefaultOptionTile(
              state: state,
              selectionConfig: selectionConfig,
            ),
      ),
    );
  }
}

class _DefaultOptionTile<T> extends StatelessWidget {
  const _DefaultOptionTile({
    required this.state,
    required this.selectionConfig,
  });

  final AutocompleteOptionState<T> state;
  final AutocompleteSelectionConfig<T> selectionConfig;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.label,
              style: state.isDisabled
                  ? textStyle?.copyWith(color: Theme.of(context).disabledColor)
                  : textStyle,
            ),
          ),
          if (state.isSelected && selectionConfig.showSelectionIndicator)
            selectionConfig.selectionIndicatorBuilder?.call(context, state) ??
                const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }
}
