/// Defines how many values an autocomplete field can hold at once.
///
/// This enum is internal wiring for constructor-specific behavior and is not a
/// user-facing "mode toggle" at runtime.
enum AutocompleteSelectionMode {
  /// Exactly zero or one selected value.
  single,

  /// Zero or more selected values.
  multiple,
}
