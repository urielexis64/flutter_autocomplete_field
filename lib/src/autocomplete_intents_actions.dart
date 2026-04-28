import 'package:flutter/widgets.dart';

/// Intent for moving the autocomplete highlight down.
class AutocompleteHighlightNextIntent extends Intent {
  /// Creates a highlight-next intent.
  const AutocompleteHighlightNextIntent();
}

/// Intent for moving the autocomplete highlight up.
class AutocompleteHighlightPreviousIntent extends Intent {
  /// Creates a highlight-previous intent.
  const AutocompleteHighlightPreviousIntent();
}

/// Intent for selecting the highlighted autocomplete option.
class AutocompleteSelectHighlightedIntent extends Intent {
  /// Creates a select-highlighted intent.
  const AutocompleteSelectHighlightedIntent();
}

/// Intent for closing the autocomplete popup.
class AutocompleteCloseIntent extends Intent {
  /// Creates a close intent.
  const AutocompleteCloseIntent();
}

/// Intent for clearing the autocomplete value and input.
class AutocompleteClearIntent extends Intent {
  /// Creates a clear intent.
  const AutocompleteClearIntent();
}

/// Intent for moving the autocomplete highlight to the first option.
class AutocompleteFirstOptionIntent extends Intent {
  /// Creates a first-option intent.
  const AutocompleteFirstOptionIntent();
}

/// Intent for moving the autocomplete highlight to the last option.
class AutocompleteLastOptionIntent extends Intent {
  /// Creates a last-option intent.
  const AutocompleteLastOptionIntent();
}

/// Intent for removing the last selected chip.
class AutocompleteRemoveLastChipIntent extends Intent {
  /// Creates a remove-last-chip intent.
  const AutocompleteRemoveLastChipIntent();
}
