/// Shared interaction behavior for an autocomplete field.
class AutocompleteBehaviorConfig {
  /// Creates behavior flags used by all field modes.
  ///
  /// Throws an [AssertionError] when [disableCloseOnSelect] and
  /// [closeOnSelect] are both `true`, because those settings conflict.
  const AutocompleteBehaviorConfig({
    this.openOnFocus = true,
    this.autoHighlight = false,
    this.clearOnBlur = true,
    this.blurOnSelect = false,
    this.disableCloseOnSelect = false,
    this.filterSelectedOptions = false,
    this.closeOnSelect = true,
    this.clearInputOnSelect = false,
    this.showOptionsOnEmptyInput = true,
    this.toggleSelectionOnTap = true,
  }) : assert(
          !(disableCloseOnSelect && closeOnSelect),
          'disableCloseOnSelect and closeOnSelect cannot both be true.',
        );

  /// Opens the popup when the field receives focus.
  final bool openOnFocus;

  /// Marks the first visible option as highlighted.
  ///
  /// This affects rendering only and does not implement keyboard navigation.
  final bool autoHighlight;

  /// Clears active query text when focus is lost.
  ///
  /// In single mode, this may reset the visible text back to the selected
  /// value label.
  final bool clearOnBlur;

  /// Removes focus from the field after selecting or deselecting an option.
  final bool blurOnSelect;

  /// Prevents the popup from closing after selection.
  ///
  /// Use this mostly for multiple mode flows where users pick many options.
  final bool disableCloseOnSelect;

  /// Deprecated compatibility-style flag retained for API parity.
  ///
  /// The current package behavior is driven by [AutocompleteSelectionConfig].
  /// This flag is currently not consumed by the internal selection pipeline.
  final bool filterSelectedOptions;

  /// Closes the popup after selection when [disableCloseOnSelect] is `false`.
  final bool closeOnSelect;

  /// Clears input text after selecting or deselecting an option.
  ///
  /// In multiple mode this helps users continue entering additional values.
  final bool clearInputOnSelect;

  /// Allows showing options when the query input is empty.
  final bool showOptionsOnEmptyInput;

  /// Allows tapping an already-selected option in the popup to unselect it.
  final bool toggleSelectionOnTap;
}
