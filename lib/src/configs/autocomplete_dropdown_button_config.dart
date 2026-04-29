import 'package:flutter/material.dart';

/// Configures the dropdown indicator shown by the field.
class AutocompleteDropdownButtonConfig {
  /// Creates dropdown-button configuration.
  const AutocompleteDropdownButtonConfig({
    this.enabled = true,
    this.tooltip = 'Show options',
    this.closedIcon = const Icon(Icons.arrow_drop_down),
    this.openIcon = const Icon(Icons.arrow_drop_up),
  });

  /// Whether the dropdown indicator can be shown.
  final bool enabled;

  /// Tooltip text for accessibility and long-press hints.
  final String tooltip;

  /// Icon displayed when the popup is currently closed.
  final Widget closedIcon;

  /// Icon displayed when the popup is currently open.
  final Widget openIcon;
}
