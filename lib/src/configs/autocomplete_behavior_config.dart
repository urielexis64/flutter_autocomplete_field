/// Shared interaction behavior for an autocomplete field.
class AutocompleteBehaviorConfig {
  const AutocompleteBehaviorConfig({
    this.openOnFocus = true,
    this.autoHighlight = false,
    this.clearOnBlur = false,
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

  final bool openOnFocus;
  final bool autoHighlight;
  final bool clearOnBlur;
  final bool blurOnSelect;
  final bool disableCloseOnSelect;
  final bool filterSelectedOptions;
  final bool closeOnSelect;
  final bool clearInputOnSelect;
  final bool showOptionsOnEmptyInput;

  /// Allows tapping an already-selected option in the popup to unselect it.
  final bool toggleSelectionOnTap;
}
