import 'package:flutter/widgets.dart';

/// Converts an option into the user-visible label shown in the input and list.
typedef AutocompleteOptionLabel<T> = String Function(T option);

/// Returns a stable key for an option.
///
/// MUI documents this as important when duplicate labels exist because the
/// option label alone is not a stable identity.
typedef AutocompleteOptionKey<T> = Object Function(T option);

/// Returns whether [option] and [value] represent the same logical item.
///
/// Object options often need custom equality, matching MUI's
/// `isOptionEqualToValue` guidance where strict identity is not sufficient.
typedef AutocompleteOptionEquality<T> = bool Function(T option, T value);

/// Returns whether an option should be visible but not selectable.
typedef AutocompleteOptionDisabled<T> = bool Function(T option);

/// Returns the group label for an option.
///
/// MUI recommends sorting by this same value before grouping. This package
/// coalesces matching group values even when options are not pre-sorted.
typedef AutocompleteOptionGroupBy<T> = String Function(T option);

/// Filters [options] using the current [state].
typedef AutocompleteFilterCallback<T> =
    List<T> Function(List<T> options, AutocompleteFilterState<T> state);

/// Loads options for a query, usually for search-as-you-type flows.
typedef AutocompleteAsyncOptionsBuilder<T> =
    Future<List<T>> Function(String query);

/// Loads options when the popup is first opened.
typedef AutocompleteLoadOptionsOnOpen<T> = Future<List<T>> Function();

/// Builds a popup option row.
typedef AutocompleteOptionBuilder<T> =
    Widget Function(
      BuildContext context,
      T option,
      AutocompleteOptionState state,
    );

/// Builds a group header or grouped section.
///
/// [AutocompleteField] uses this builder as a sticky header renderer when
/// sticky grouped scrolling is enabled. In that mode [children] is empty
/// because the option rows are rendered in their own scroll sliver.
typedef AutocompleteGroupBuilder =
    Widget Function(BuildContext context, String group, List<Widget> children);

/// Builds a custom widget for one selected value.
typedef AutocompleteSelectedItemBuilder<T> =
    Widget Function(
      BuildContext context,
      T value,
      AutocompleteSelectedItemState state,
    );

/// Builds a selected chip in multiple-selection mode.
///
/// This is a chip-specific alternative to [AutocompleteSelectedItemBuilder].
typedef AutocompleteChipBuilder<T> =
    Widget Function(
      BuildContext context,
      T value,
      AutocompleteSelectedItemState state,
    );

/// Builds a custom widget for all selected values in multiple mode.
typedef AutocompleteSelectedItemsBuilder<T> =
    Widget Function(
      BuildContext context,
      List<T> values,
      AutocompleteSelectedItemsState state,
    );

/// Size variants for the text field, option rows, and chips.
enum AutocompleteSize {
  /// Standard Material text field and option density.
  medium,

  /// Compact text field, option rows, and chips.
  small,
}

/// Layout strategy for selected chips in multiple-selection mode.
enum AutocompleteChipLayout {
  /// Chips wrap onto additional lines as needed.
  wrap,

  /// Chips stay on one horizontal scrolling line.
  horizontalScroll,
}

/// Match placement used by [createAutocompleteFilter].
enum AutocompleteFilterMatchFrom {
  /// Match anywhere in the stringified option.
  any,

  /// Match only from the start of the stringified option.
  start,
}

/// Why the selected value changed.
enum AutocompleteValueChangedReason {
  /// The user selected an existing option.
  selectOption,

  /// The user created a value from typed free-solo text.
  createOption,

  /// The user removed one selected value.
  removeOption,

  /// The user cleared all selected values.
  clear,

  /// The value was finalized while the field lost focus.
  blur,
}

/// Why the input text changed.
enum AutocompleteInputChangedReason {
  /// The user typed or edited text.
  input,

  /// The input text was reset to reflect a selected option.
  reset,

  /// The input text was cleared.
  clear,

  /// The input text changed because an option was selected.
  selectOption,

  /// The input text changed during blur handling.
  blur,
}

/// Why the popup closed.
enum AutocompleteCloseReason {
  /// The user toggled the popup from the input affordance.
  toggleInput,

  /// The user pressed Escape.
  escape,

  /// The popup closed after a selection.
  selectOption,

  /// The field lost focus.
  blur,

  /// The popup closed after a value was removed.
  removeOption,
}

/// State passed to an option builder.
class AutocompleteOptionState {
  /// Creates immutable option rendering state.
  const AutocompleteOptionState({
    required this.index,
    required this.highlighted,
    required this.selected,
    required this.disabled,
    required this.inputValue,
  });

  /// Index in the filtered option list.
  final int index;

  /// Whether keyboard focus/highlight currently points at this option.
  final bool highlighted;

  /// Whether this option is already selected.
  final bool selected;

  /// Whether this option is visible but disabled.
  final bool disabled;

  /// Current text input value.
  final String inputValue;
}

/// State passed to a selected item builder.
class AutocompleteSelectedItemState {
  /// Creates immutable selected item rendering state.
  const AutocompleteSelectedItemState({
    required this.index,
    required this.disabled,
    required this.focused,
    required this.onRemove,
  });

  /// Index in the selected values list.
  final int index;

  /// Whether the selected item is fixed and cannot be removed.
  final bool disabled;

  /// Whether the autocomplete field currently has focus.
  final bool focused;

  /// Removes the selected value when non-null.
  final VoidCallback? onRemove;
}

/// State passed to a selected items builder.
class AutocompleteSelectedItemsState {
  /// Creates immutable selected items rendering state.
  const AutocompleteSelectedItemsState({
    required this.focused,
    required this.limitTags,
    required this.hiddenCount,
  });

  /// Whether the autocomplete field currently has focus.
  final bool focused;

  /// Maximum number of tags shown while the field is not focused.
  final int? limitTags;

  /// Number of selected values hidden by [limitTags].
  final int hiddenCount;
}

/// Input passed to a filter callback.
class AutocompleteFilterState<T> {
  /// Creates filter state for [inputValue] and [getOptionLabel].
  const AutocompleteFilterState({
    required this.inputValue,
    required this.getOptionLabel,
  });

  /// Current text entered by the user.
  final String inputValue;

  /// Label resolver used by the default filter.
  final AutocompleteOptionLabel<T> getOptionLabel;
}
