import 'package:flutter/material.dart';

/// Configures the clear action shown by the field.
class AutocompleteClearButtonConfig {
  const AutocompleteClearButtonConfig({
    this.enabled = true,
    this.tooltip = 'Clear',
    this.icon = const Icon(Icons.close),
  });

  final bool enabled;
  final String tooltip;
  final Widget icon;
}
