import 'package:flutter/material.dart';

import '../configs/autocomplete_selection_config.dart';
import '../models/autocomplete_option_state.dart';

/// Interactive popup row for one autocomplete option.
///
/// The tile can be rendered with a custom [builder] or a built-in default that
/// shows label text and an optional selected indicator.
class PopupOptionTile<T> extends StatelessWidget {
  /// Creates a popup option tile.
  const PopupOptionTile({
    required this.state,
    required this.onTap,
    required this.builder,
    required this.selectionConfig,
    this.tileKey,
    super.key,
  });

  /// Immutable option snapshot used for rendering decisions.
  final AutocompleteOptionState<T> state;

  /// Tap callback, ignored when [state.isDisabled] is `true`.
  final VoidCallback? onTap;

  /// Optional custom row builder.
  final Widget Function(
    BuildContext context,
    AutocompleteOptionState<T> option,
  )? builder;

  /// Selection rendering config used by the default tile.
  final AutocompleteSelectionConfig<T> selectionConfig;

  /// Optional key forwarded to the tappable surface.
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

/// Built-in option row used when no custom option builder is supplied.
class _DefaultOptionTile<T> extends StatelessWidget {
  /// Creates the default popup option row used when no custom builder exists.
  const _DefaultOptionTile({
    required this.state,
    required this.selectionConfig,
  });

  /// Immutable option snapshot.
  final AutocompleteOptionState<T> state;

  /// Selection rendering behavior.
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
