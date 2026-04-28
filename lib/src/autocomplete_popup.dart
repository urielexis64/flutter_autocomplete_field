import 'package:flutter/material.dart';

import 'autocomplete_theme.dart';
import 'autocomplete_types.dart';
import 'utils/option_grouping.dart';

/// Popup listbox for [AutocompleteField].
///
/// It supports grouped options, disabled options, selected semantics, and a
/// builder-backed virtualized mode for large lists.
class AutocompletePopup<T> extends StatefulWidget {
  /// Creates an autocomplete popup.
  const AutocompletePopup({
    super.key,
    required this.options,
    required this.getOptionLabel,
    required this.getOptionKey,
    required this.isOptionSelected,
    required this.isOptionDisabled,
    required this.highlightedIndex,
    required this.inputValue,
    required this.onOptionTap,
    required this.onOptionHover,
    required this.theme,
    this.groupBy,
    this.optionBuilder,
    this.groupBuilder,
    this.stickyGroupHeaders = true,
    this.groupHeaderHeight = 32,
    this.size = AutocompleteSize.medium,
    this.maxHeight = 280,
    this.virtualized = false,
    this.loading = false,
    this.loadingText = 'Loading...',
    this.noOptionsText = 'No options',
  });

  /// Options to render.
  final List<T> options;

  /// Label resolver for option text.
  final AutocompleteOptionLabel<T> getOptionLabel;

  /// Stable key resolver for options with duplicate labels.
  final AutocompleteOptionKey<T> getOptionKey;

  /// Returns whether an option is selected.
  final bool Function(T option) isOptionSelected;

  /// Returns whether an option is disabled.
  final bool Function(T option) isOptionDisabled;

  /// Highlighted index in [options], or `-1`.
  final int highlightedIndex;

  /// Current text input value.
  final String inputValue;

  /// Called when an enabled option is tapped.
  final ValueChanged<T> onOptionTap;

  /// Called when pointer hover moves over an enabled option index.
  final ValueChanged<int> onOptionHover;

  /// Optional group resolver.
  final AutocompleteOptionGroupBy<T>? groupBy;

  /// Optional option row builder.
  final AutocompleteOptionBuilder<T>? optionBuilder;

  /// Optional grouped header/section builder.
  final AutocompleteGroupBuilder? groupBuilder;

  /// Whether grouped headers should pin to the top while scrolling.
  final bool stickyGroupHeaders;

  /// Height used by grouped headers and sticky header delegates.
  final double groupHeaderHeight;

  /// Theme values used by the popup.
  final AutocompleteThemeData theme;

  /// Visual density.
  final AutocompleteSize size;

  /// Maximum popup height.
  final double maxHeight;

  /// Whether to use `ListView.builder` for large lists.
  final bool virtualized;

  /// Whether to show a loading row.
  final bool loading;

  /// Text displayed while loading.
  final String loadingText;

  /// Text displayed when no options match.
  final String noOptionsText;

  @override
  State<AutocompletePopup<T>> createState() => _AutocompletePopupState<T>();
}

class _AutocompletePopupState<T> extends State<AutocompletePopup<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AutocompletePopup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlightedIndex != widget.highlightedIndex) {
      _scrollHighlightedOptionIntoView();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);
    return Semantics(
      container: true,
      label: 'Autocomplete options',
      child: Material(
        color: widget.theme.popupColor,
        elevation: widget.theme.popupElevation,
        borderRadius: widget.theme.popupBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          child: child,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.loading && widget.options.isEmpty) {
      return _StatusRow(
        text: widget.loadingText,
        loading: true,
        height: widget.theme.rowHeightFor(widget.size),
      );
    }
    if (widget.options.isEmpty) {
      return _StatusRow(
        text: widget.noOptionsText,
        loading: false,
        height: widget.theme.rowHeightFor(widget.size),
      );
    }

    if (widget.groupBy != null && widget.stickyGroupHeaders) {
      return _buildStickyGroupedScrollView(context);
    }

    if (!widget.virtualized &&
        widget.groupBy != null &&
        widget.groupBuilder != null) {
      return ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: _buildCustomGroups(context),
      );
    }

    final entries = _buildEntries();
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, rowIndex) {
        final entry = entries[rowIndex];
        if (entry.group != null) {
          return _buildGroupHeader(entry.group!);
        }
        return _buildOption(context, entry.option as T, entry.optionIndex);
      },
    );
  }

  Widget _buildStickyGroupedScrollView(BuildContext context) {
    final groupBy = widget.groupBy!;
    final groups = groupAutocompleteOptionsWithIndexes(widget.options, groupBy);
    final slivers = <Widget>[];
    for (final group in groups) {
      slivers.add(
        SliverMainAxisGroup(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyGroupHeaderDelegate(
                height: widget.groupHeaderHeight,
                child: _buildStickyGroupHeader(context, group.group),
              ),
            ),
            SliverList.builder(
              itemCount: group.options.length,
              itemBuilder: (context, localIndex) {
                final entry = group.options[localIndex];
                return _buildOption(context, entry.option, entry.index);
              },
            ),
          ],
        ),
      );
    }
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: true,
      slivers: slivers,
    );
  }

  List<Widget> _buildCustomGroups(BuildContext context) {
    final groupBy = widget.groupBy!;
    final groups = groupAutocompleteOptionsWithIndexes(widget.options, groupBy);
    return groups
        .map((group) {
          final children = <Widget>[];
          for (final entry in group.options) {
            children.add(_buildOption(context, entry.option, entry.index));
          }
          return widget.groupBuilder!(context, group.group, children);
        })
        .toList(growable: false);
  }

  List<_PopupEntry<T>> _buildEntries() {
    final groupBy = widget.groupBy;
    if (groupBy == null) {
      return List<_PopupEntry<T>>.generate(
        widget.options.length,
        (index) => _PopupEntry<T>.option(widget.options[index], index),
      );
    }

    final entries = <_PopupEntry<T>>[];
    final groups = groupAutocompleteOptionsWithIndexes(widget.options, groupBy);
    for (final group in groups) {
      entries.add(_PopupEntry<T>.group(group.group));
      for (final entry in group.options) {
        entries.add(_PopupEntry<T>.option(entry.option, entry.index));
      }
    }
    return entries;
  }

  Widget _buildGroupHeader(String group) {
    return Container(
      color: widget.theme.groupHeaderColor,
      height: widget.groupHeaderHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        group,
        style: widget.theme.groupHeaderTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStickyGroupHeader(BuildContext context, String group) {
    final customHeader = widget.groupBuilder?.call(context, group, const []);
    if (customHeader != null) {
      return SizedBox(height: widget.groupHeaderHeight, child: customHeader);
    }
    return _buildGroupHeader(group);
  }

  Widget _buildOption(BuildContext context, T option, int index) {
    final selected = widget.isOptionSelected(option);
    final disabled = widget.isOptionDisabled(option);
    final highlighted = widget.highlightedIndex == index;
    final state = AutocompleteOptionState(
      index: index,
      highlighted: highlighted,
      selected: selected,
      disabled: disabled,
      inputValue: widget.inputValue,
    );
    final label = widget.getOptionLabel(option);
    final rowHeight = widget.theme.rowHeightFor(widget.size);
    final backgroundColor = highlighted
        ? widget.theme.optionHighlightColor
        : selected
        ? widget.theme.optionSelectedColor
        : Colors.transparent;

    final child =
        widget.optionBuilder?.call(context, option, state) ??
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: widget.theme.optionTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected) const Icon(Icons.check, size: 18),
          ],
        );

    return Semantics(
      key: ValueKey<Object>(widget.getOptionKey(option)),
      label: label,
      selected: selected,
      enabled: !disabled,
      button: true,
      child: MouseRegion(
        onEnter: disabled ? null : (_) => widget.onOptionHover(index),
        child: InkWell(
          onTap: disabled ? null : () => widget.onOptionTap(option),
          child: Container(
            height: rowHeight,
            color: backgroundColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundDecoration: disabled
                ? BoxDecoration(color: Colors.white.withValues(alpha: 0.45))
                : null,
            child: Opacity(opacity: disabled ? 0.55 : 1, child: child),
          ),
        ),
      ),
    );
  }

  void _scrollHighlightedOptionIntoView() {
    if (widget.highlightedIndex < 0) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final target = _optionScrollOffset(
        widget.highlightedIndex,
      ).clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.jumpTo(target);
    });
  }

  double _optionScrollOffset(int optionIndex) {
    final rowHeight = widget.theme.rowHeightFor(widget.size);
    final groupBy = widget.groupBy;
    if (groupBy == null) {
      return optionIndex * rowHeight;
    }

    final groups = groupAutocompleteOptionsWithIndexes(widget.options, groupBy);
    var offset = 0.0;
    for (final group in groups) {
      offset += widget.groupHeaderHeight;
      for (final entry in group.options) {
        if (entry.index == optionIndex) {
          return offset;
        }
        offset += rowHeight;
      }
    }
    return offset;
  }
}

class _StickyGroupHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyGroupHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyGroupHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _PopupEntry<T> {
  _PopupEntry.group(this.group) : option = null, optionIndex = -1;

  _PopupEntry.option(this.option, this.optionIndex) : group = null;

  final String? group;
  final T? option;
  final int optionIndex;
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.text,
    required this.loading,
    required this.height,
  });

  final String text;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
