import 'package:flutter/material.dart';

import '../configs/autocomplete_selection_config.dart';
import '../enums/autocomplete_highlight_match_scope.dart';
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
    this.highlightMatchesInDefaultOption = true,
    this.highlightMatchCaseSensitive = false,
    this.highlightMatchScope = AutocompleteHighlightMatchScope.allOccurrences,
    this.highlightedMatchTextStyle,
    this.tileKey,
    this.isGrouping = false,
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

  /// Whether the built-in tile highlights query matches in [state.label].
  final bool highlightMatchesInDefaultOption;

  /// Whether default match highlighting should be case-sensitive.
  final bool highlightMatchCaseSensitive;

  /// Whether highlights include all matches or only the first.
  final AutocompleteHighlightMatchScope highlightMatchScope;

  /// Optional style used by highlighted text segments in the default tile.
  final TextStyle? highlightedMatchTextStyle;

  /// Optional key forwarded to the tappable surface.
  final Key? tileKey;

  /// Optional flag to know if the overlay has group headers.
  final bool isGrouping;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = state.isHighlighted
        ? theme.colorScheme.surfaceContainerHighest
        : state.isSelected
            ? theme.colorScheme.secondaryContainer
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
              highlightMatchesInDefaultOption: highlightMatchesInDefaultOption,
              highlightMatchCaseSensitive: highlightMatchCaseSensitive,
              highlightMatchScope: highlightMatchScope,
              highlightedMatchTextStyle: highlightedMatchTextStyle,
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
    required this.highlightMatchesInDefaultOption,
    required this.highlightMatchCaseSensitive,
    required this.highlightMatchScope,
    this.highlightedMatchTextStyle,
    this.isGrouping = false,
  });

  /// Immutable option snapshot.
  final AutocompleteOptionState<T> state;

  /// Selection rendering behavior.
  final AutocompleteSelectionConfig<T> selectionConfig;

  /// Whether to highlight query matches in the label.
  final bool highlightMatchesInDefaultOption;

  /// Whether highlight matching is case-sensitive.
  final bool highlightMatchCaseSensitive;

  /// Whether highlights include all matches or only the first.
  final AutocompleteHighlightMatchScope highlightMatchScope;

  /// Optional style for highlighted segments.
  final TextStyle? highlightedMatchTextStyle;

  /// Optional flag to know if the overlay has group headers.
  final bool isGrouping;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final effectiveTextStyle = state.isDisabled
        ? textStyle?.copyWith(color: Theme.of(context).disabledColor)
        : textStyle;
    final leftPadding = isGrouping ? 24.0 : 16.0;
    return Padding(
      padding:
          EdgeInsets.only(left: leftPadding, right: 16, top: 14, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: _buildLabel(context, effectiveTextStyle),
          ),
          if (state.isSelected && selectionConfig.showSelectionIndicator)
            selectionConfig.selectionIndicatorBuilder?.call(context, state) ??
                const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, TextStyle? textStyle) {
    final input = state.input.trim();
    if (!highlightMatchesInDefaultOption || input.isEmpty) {
      return Text(state.label, style: textStyle);
    }

    return Text.rich(
      TextSpan(
        style: textStyle,
        children: _buildHighlightSpans(
          context: context,
          label: state.label,
          query: input,
          baseStyle: textStyle,
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightSpans({
    required BuildContext context,
    required String label,
    required String query,
    required TextStyle? baseStyle,
  }) {
    final source = highlightMatchCaseSensitive ? label : label.toLowerCase();
    final target = highlightMatchCaseSensitive ? query : query.toLowerCase();
    if (target.isEmpty) {
      return <TextSpan>[TextSpan(text: label, style: baseStyle)];
    }

    final highlightStyle = highlightedMatchTextStyle ??
        baseStyle?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ) ??
        TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        );

    final spans = <TextSpan>[];
    var start = 0;
    var highlightedCount = 0;
    while (start < label.length) {
      final matchIndex = source.indexOf(target, start);
      if (matchIndex < 0) {
        spans.add(
          TextSpan(text: label.substring(start), style: baseStyle),
        );
        break;
      }

      if (matchIndex > start) {
        spans.add(
          TextSpan(text: label.substring(start, matchIndex), style: baseStyle),
        );
      }

      final matchEnd = matchIndex + target.length;
      final shouldHighlight =
          highlightMatchScope == AutocompleteHighlightMatchScope.allOccurrences
              ? true
              : highlightedCount == 0;
      spans.add(
        TextSpan(
          text: label.substring(matchIndex, matchEnd),
          style: shouldHighlight ? highlightStyle : baseStyle,
        ),
      );
      if (shouldHighlight) {
        highlightedCount += 1;
      }
      start = matchEnd;
    }

    return spans.isEmpty
        ? <TextSpan>[TextSpan(text: label, style: baseStyle)]
        : spans;
  }
}
