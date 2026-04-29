/// Internal layout constants shared by autocomplete components.
///
/// These defaults intentionally stay private to package internals and can be
/// tuned without changing the public API surface.
class AutocompleteDefaults {
  /// Fixed height used by default group headers in the popup.
  static const double popupHeaderExtent = 40;

  /// Minimum width reserved for the editable input in multiple mode.
  static const double chipInputMinWidth = 72;

  /// Extra width added to measured input text for comfortable caret spacing.
  static const double chipInputHorizontalPadding = 12;
}
