import 'package:flutter/material.dart';

import '../autocomplete/grouped_options.dart';
import '../configs/autocomplete_grouping_config.dart';
import '../configs/autocomplete_popup_config.dart';
import '../configs/autocomplete_rendering_config.dart';
import '../configs/autocomplete_selection_config.dart';
import '../enums/autocomplete_highlight_match_scope.dart';
import '../models/autocomplete_option_group.dart';
import '../models/autocomplete_option_state.dart';
import '../models/autocomplete_typedefs.dart';
import '../theme/autocomplete_defaults.dart';
import 'group_header_delegate.dart';
import 'popup_option_tile.dart';

/// Popup surface that renders autocomplete options, loading, and empty states.
///
/// This widget is purely visual. It does not own selection state, filtering, or
/// async orchestration. Those responsibilities live in
/// `AutocompleteFieldView`.
///
/// Grouping is presentation-only and can be enabled through
/// [groupingConfig]. Creatable actions are always rendered outside groups.
class AutocompletePopup<T> extends StatelessWidget {
  /// Creates an autocomplete popup.
  ///
  /// All callbacks are expected to be side-effect safe. This widget may rebuild
  /// often while users type or async states change.
  const AutocompletePopup({
    required this.options,
    required this.query,
    required this.getOptionLabel,
    required this.isSelected,
    required this.onOptionTap,
    required this.popupConfig,
    required this.selectionConfig,
    this.groupingConfig,
    this.renderingConfig,
    this.isLoading = false,
    this.isOptionDisabled,
    this.highlightedOption,
    this.createInput,
    this.createLabel,
    this.onCreateTap,
    this.createOptionBuilder,
    this.onReachedListEnd,
    this.loadMoreTriggerOffset = 120,
    this.isLoadingMore = false,
    this.hasMoreResults = false,
    this.loadingMoreBuilder,
    this.endOfListBuilder,
    this.showEndOfListIndicator = false,
    super.key,
  });

  /// Options already filtered by the parent field.
  final List<T> options;

  /// Current query used for loading/empty builders.
  final String query;

  /// Label resolver for options.
  final AutocompleteOptionLabel<T> getOptionLabel;

  /// Reports whether an option is currently selected.
  final bool Function(T option) isSelected;

  /// Optional disabled-state predicate for options.
  final bool Function(T option)? isOptionDisabled;

  /// Called when a regular option is tapped.
  final ValueChanged<T> onOptionTap;

  /// Popup geometry and styling configuration.
  final AutocompletePopupConfig popupConfig;

  /// Selection rendering behavior for option rows.
  final AutocompleteSelectionConfig<T> selectionConfig;

  /// Optional visual grouping configuration.
  final AutocompleteGroupingConfig<T>? groupingConfig;

  /// Optional custom renderers for loading, empty, groups, and options.
  final AutocompleteRenderingConfig<T>? renderingConfig;

  /// Whether async options are currently loading.
  final bool isLoading;

  /// Option that should appear visually highlighted.
  final T? highlightedOption;

  /// Input shown as synthetic creatable option, when available.
  final String? createInput;

  /// Optional label override for the creatable option.
  final String? createLabel;

  /// Tap callback for the creatable option.
  final VoidCallback? onCreateTap;

  /// Optional custom builder for the creatable option row.
  final Widget Function(BuildContext context, String input)?
      createOptionBuilder;

  /// Callback fired when popup scrolling reaches near the bottom.
  final VoidCallback? onReachedListEnd;

  /// Distance from list end that triggers [onReachedListEnd].
  final double loadMoreTriggerOffset;

  /// Whether an additional page is currently loading.
  final bool isLoadingMore;

  /// Whether more paginated results are available.
  final bool hasMoreResults;

  /// Optional footer builder shown while loading more results.
  final Widget Function(BuildContext context)? loadingMoreBuilder;

  /// Optional footer builder shown when no more results are available.
  final Widget Function(BuildContext context)? endOfListBuilder;

  /// Whether to show end-of-list footer when [hasMoreResults] is `false`.
  final bool showEndOfListIndicator;

  @override
  Widget build(BuildContext context) {
    final child = isLoading ? _buildLoading(context) : _buildContent(context);
    final animatedChild = popupConfig.heightAnimationDuration == Duration.zero
        ? child
        : AnimatedSize(
            duration: popupConfig.heightAnimationDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: child,
          );

    return Material(
      key: const ValueKey<String>('autocomplete-popup-surface'),
      elevation: popupConfig.elevation,
      borderRadius: popupConfig.borderRadius,
      clipBehavior: Clip.antiAlias,
      color: popupConfig.backgroundColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: popupConfig.backgroundColor ??
              Theme.of(context).colorScheme.surface,
          borderRadius: popupConfig.borderRadius,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: popupConfig.maxHeight),
          child: animatedChild,
        ),
      ),
    );
  }

  /// Builds the loading placeholder while options are in-flight.
  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: popupConfig.emptyStateHeight,
      child: Padding(
        padding: popupConfig.padding,
        child: renderingConfig?.loadingBuilder?.call(context, query) ??
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  /// Builds the non-loading popup body (options, groups, or empty state).
  Widget _buildContent(BuildContext context) {
    if (options.isEmpty && createInput == null) {
      return SizedBox(
        height: popupConfig.emptyStateHeight,
        child: Padding(
          padding: popupConfig.padding,
          child: renderingConfig?.emptyBuilder?.call(context, query) ??
              Center(
                child: Text(
                  'No options',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RawScrollbar(
        padding: EdgeInsets.zero,
        interactive: false,
        child: CustomScrollView(
          primary: false,
          shrinkWrap: true,
          slivers: _buildSlivers(context),
        ),
      ),
    );
  }

  /// Produces outer slivers with popup edge padding applied.
  List<Widget> _buildSlivers(BuildContext context) {
    final contentSlivers = _buildContentSlivers(context);
    final resolvedPadding = popupConfig.padding.resolve(
      Directionality.of(context),
    );
    final horizontalPadding = EdgeInsets.only(
      left: resolvedPadding.left,
      right: resolvedPadding.right,
    );
    final verticalPadding = EdgeInsets.only(
      top: resolvedPadding.top,
      bottom: resolvedPadding.bottom,
    );

    final slivers = <Widget>[
      if (verticalPadding.top > 0)
        SliverToBoxAdapter(child: SizedBox(height: verticalPadding.top)),
      ...contentSlivers,
      if (isLoadingMore)
        SliverToBoxAdapter(
          child: loadingMoreBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
        ),
      if (!isLoadingMore &&
          !hasMoreResults &&
          showEndOfListIndicator &&
          endOfListBuilder != null)
        SliverToBoxAdapter(child: endOfListBuilder!.call(context)),
      if (verticalPadding.bottom > 0)
        SliverToBoxAdapter(child: SizedBox(height: verticalPadding.bottom)),
    ];

    if (horizontalPadding == EdgeInsets.zero) {
      return slivers;
    }

    return slivers
        .map(
          (sliver) => SliverPadding(
            padding: horizontalPadding,
            sliver: sliver,
          ),
        )
        .toList(growable: false);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (onReachedListEnd != null &&
        !isLoading &&
        !isLoadingMore &&
        hasMoreResults &&
        options.isNotEmpty &&
        notification.metrics.axis == Axis.vertical) {
      final remaining =
          notification.metrics.maxScrollExtent - notification.metrics.pixels;
      if (remaining <= loadMoreTriggerOffset) {
        onReachedListEnd!.call();
      }
    }

    // Prevent ancestor scroll views with `keyboardDismissBehavior.onDrag`
    // from treating popup scrolling as an outside drag and closing the field.
    return true;
  }

  /// Produces content slivers for grouped/flat options and creatable action.
  ///
  /// Creatable action is intentionally appended only when there are no regular
  /// options so it remains visually distinct from grouped results.
  List<Widget> _buildContentSlivers(BuildContext context) {
    final groups = buildAutocompleteGroups(options, groupingConfig);
    final slivers = <Widget>[];

    if (groups.isEmpty) {
      slivers.add(_buildFlatOptionsSliver(context, options));
    } else if (groupingConfig?.stickyHeaders ?? false) {
      for (final group in groups) {
        slivers.add(
          SliverMainAxisGroup(
            slivers: [
              _buildStickyGroupHeader(context, group.name),
              _buildFlatOptionsSliver(context, group.options),
            ],
          ),
        );
      }
    } else {
      for (final group in groups) {
        slivers.add(_buildGroupedSection(context, group));
      }
    }

    if (createInput != null && options.isEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: PopupOptionTile<String>(
            state: AutocompleteOptionState<String>(
              option: createInput!,
              label: createInput!,
              input: query,
              isSelected: false,
              isDisabled: false,
              isHighlighted: false,
            ),
            isGrouping: groupingConfig?.groupBy != null,
            onTap: onCreateTap,
            selectionConfig: const AutocompleteSelectionConfig<String>(),
            tileKey:
                ValueKey<String>('autocomplete-create-option-$createInput'),
            builder: (context, state) =>
                createOptionBuilder?.call(context, state.option) ??
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Text(createLabel ?? 'Add "${state.option}"'),
                ),
          ),
        ),
      );
    }

    return slivers;
  }

  /// Builds a simple sliver list for [groupOptions].
  Widget _buildFlatOptionsSliver(BuildContext context, List<T> groupOptions) {
    return SliverList.builder(
      itemCount: groupOptions.length,
      itemBuilder: (context, index) {
        final option = groupOptions[index];
        return _buildOption(context, option);
      },
    );
  }

  /// Builds a non-sticky grouped section.
  Widget _buildGroupedSection(
    BuildContext context,
    AutocompleteOptionGroup<T> group,
  ) {
    final optionWidgets = group.options
        .map((option) => _buildOption(context, option))
        .toList(growable: false);
    final section = renderingConfig?.groupBuilder?.call(
          context,
          group.name,
          optionWidgets,
        ) ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDefaultHeader(context, group.name),
            ...optionWidgets,
          ],
        );
    return SliverToBoxAdapter(child: section);
  }

  /// Builds a sticky/pinned header for one option group.
  Widget _buildStickyGroupHeader(BuildContext context, String group) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: GroupHeaderDelegate(
        extent: AutocompleteDefaults.popupHeaderExtent,
        child: _buildDefaultHeader(context, group),
      ),
    );
  }

  /// Builds the effective group header, using user override when provided.
  Widget _buildDefaultHeader(BuildContext context, String group) {
    final customHeader = groupingConfig?.groupHeaderBuilder?.call(
      context,
      group,
    );
    if (customHeader != null) {
      return SizedBox(
        height: AutocompleteDefaults.popupHeaderExtent,
        child: customHeader,
      );
    }
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(group, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  /// Builds one tappable option row.
  Widget _buildOption(BuildContext context, T option) {
    final label = getOptionLabel(option);
    final disabled = isOptionDisabled?.call(option) ?? false;
    return PopupOptionTile<T>(
      state: AutocompleteOptionState<T>(
        option: option,
        label: label,
        input: query,
        isSelected: isSelected(option),
        isDisabled: disabled,
        isHighlighted: highlightedOption != null
            ? identical(option, highlightedOption) ||
                getOptionLabel(highlightedOption as T) == label
            : false,
      ),
      isGrouping: groupingConfig?.groupBy != null,
      onTap: () => onOptionTap(option),
      builder: renderingConfig?.optionBuilder,
      selectionConfig: selectionConfig,
      highlightMatchesInDefaultOption:
          renderingConfig?.highlightMatchesInDefaultOption ?? true,
      highlightMatchCaseSensitive:
          renderingConfig?.highlightMatchCaseSensitive ?? false,
      highlightMatchScope: renderingConfig?.highlightMatchScope ??
          AutocompleteHighlightMatchScope.allOccurrences,
      highlightedMatchTextStyle: renderingConfig?.highlightedMatchTextStyle,
      tileKey: ValueKey<String>('autocomplete-option-$label'),
    );
  }
}
