import 'package:flutter/material.dart';

/// Configures the dropdown indicator shown by the field.
class AutocompleteDropdownButtonConfig {
  const AutocompleteDropdownButtonConfig({
    this.enabled = true,
    this.tooltip = 'Show options',
    this.closedIcon = const Icon(Icons.arrow_drop_down),
    this.openIcon = const Icon(Icons.arrow_drop_up),
  });

  final bool enabled;
  final String tooltip;
  final Widget closedIcon;
  final Widget openIcon;
}
