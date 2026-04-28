import 'package:flutter/material.dart';

import '../autocomplete/grouped_options.dart';
import '../configs/autocomplete_grouping_config.dart';
import '../configs/autocomplete_popup_config.dart';
import '../configs/autocomplete_rendering_config.dart';
import '../configs/autocomplete_selection_config.dart';
import '../models/autocomplete_option_group.dart';
import '../models/autocomplete_option_state.dart';
import '../models/autocomplete_typedefs.dart';
import '../theme/autocomplete_defaults.dart';
import 'group_header_delegate.dart';
import 'popup_option_tile.dart';

class AutocompletePopup<T> extends StatelessWidget {
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
    super.key,
  });

  final List<T> options;
  final String query;
  final AutocompleteOptionLabel<T> getOptionLabel;
  final bool Function(T option) isSelected;
  final bool Function(T option)? isOptionDisabled;
  final ValueChanged<T> onOptionTap;
  final AutocompletePopupConfig popupConfig;
  final AutocompleteSelectionConfig<T> selectionConfig;
  final AutocompleteGroupingConfig<T>? groupingConfig;
  final AutocompleteRenderingConfig<T>? renderingConfig;
  final bool isLoading;
  final T? highlightedOption;
  final String? createInput;
  final String? createLabel;
  final VoidCallback? onCreateTap;
  final Widget Function(BuildContext context, String input)?
      createOptionBuilder;

  @override
  Widget build(BuildContext context) {
    final child = isLoading ? _buildLoading(context) : _buildContent(context);

    return Material(
      key: const ValueKey<String>('autocomplete-popup-surface'),
      elevation: popupConfig.elevation,
      borderRadius: popupConfig.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: popupConfig.borderRadius,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: popupConfig.maxHeight),
          child: Padding(padding: popupConfig.padding, child: child),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: popupConfig.emptyStateHeight,
      child: renderingConfig?.loadingBuilder?.call(context, query) ??
          const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (options.isEmpty && createInput == null) {
      return SizedBox(
        height: popupConfig.emptyStateHeight,
        child: renderingConfig?.emptyBuilder?.call(context, query) ??
            Center(
              child: Text(
                'No options',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
      );
    }

    return Scrollbar(
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: _buildSlivers(context),
      ),
    );
  }

  List<Widget> _buildSlivers(BuildContext context) {
    final groups = buildAutocompleteGroups(options, groupingConfig);
    final slivers = <Widget>[];

    if (groups.isEmpty) {
      slivers.add(_buildFlatOptionsSliver(context, options));
    } else if (groupingConfig?.stickyHeaders ?? false) {
      for (final group in groups) {
        slivers.add(_buildStickyGroupHeader(context, group.name));
        slivers.add(_buildFlatOptionsSliver(context, group.options));
      }
    } else {
      for (final group in groups) {
        slivers.add(_buildGroupedSection(context, group));
      }
    }

    if (createInput != null) {
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

  Widget _buildFlatOptionsSliver(BuildContext context, List<T> groupOptions) {
    return SliverList.builder(
      itemCount: groupOptions.length,
      itemBuilder: (context, index) {
        final option = groupOptions[index];
        return _buildOption(context, option);
      },
    );
  }

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

  Widget _buildStickyGroupHeader(BuildContext context, String group) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: GroupHeaderDelegate(
        extent: AutocompleteDefaults.popupHeaderExtent,
        child: _buildDefaultHeader(context, group),
      ),
    );
  }

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
      onTap: () => onOptionTap(option),
      builder: renderingConfig?.optionBuilder,
      selectionConfig: selectionConfig,
      tileKey: ValueKey<String>('autocomplete-option-$label'),
    );
  }
}
