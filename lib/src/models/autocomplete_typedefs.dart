/// Maps an option value to the string label shown in the field and popup.
///
/// The callback should be deterministic for the same [option] input.
/// Inconsistent labels can produce unstable filtering and selection indicators.
typedef AutocompleteOptionLabel<T> = String Function(T option);

/// Compares an option from the available list against a selected value.
///
/// Return `true` when both values should be treated as the same semantic item.
/// This is useful when values are immutable models and identity (`==`) does not
/// represent business equality.
typedef AutocompleteOptionEquality<T> = bool Function(T option, T value);
