import 'package:flutter/material.dart';

/// Configures the clear action shown by the field.
class AutocompleteClearButtonConfig {
  /// Creates clear-button configuration.
  const AutocompleteClearButtonConfig({
    this.enabled = true,
    this.tooltip = 'Clear',
    this.icon = const Icon(Icons.close),
    this.widgetBuilder,
  });

  /// Whether the clear button can be shown when the field has clearable state.
  final bool enabled;

  /// Tooltip text announced by accessibility services.
  final String tooltip;

  /// Icon widget rendered by the clear button.
  final Widget icon;

  final Widget Function(VoidCallback onClear)? widgetBuilder;
}
