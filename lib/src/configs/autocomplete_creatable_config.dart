import 'package:flutter/widgets.dart';

String _defaultCreateLabel(String input) => 'Add "$input"';

/// Configures synthetic "create" rows for creatable modes.
///
/// The package never selects arbitrary raw text. Instead, it renders a create
/// row and calls [createOption] when the row is tapped.
class AutocompleteCreatableConfig<T> {
  const AutocompleteCreatableConfig({
    required this.createOption,
    this.createLabel = _defaultCreateLabel,
    this.shouldShowCreateOption,
    this.optionMatchesInput,
    this.createOptionBuilder,
    this.clearInputOnCreate = true,
    this.trimInput = true,
    this.minInputLength = 1,
    this.caseSensitive = false,
  }) : assert(minInputLength >= 0);

  final T Function(String input) createOption;
  final String Function(String input)? createLabel;
  final bool Function(String input, List<T> options)? shouldShowCreateOption;
  final bool Function(
    String input,
    T option,
    String Function(T option) getOptionLabel,
  )? optionMatchesInput;
  final Widget Function(BuildContext context, String input)?
      createOptionBuilder;
  final bool clearInputOnCreate;
  final bool trimInput;
  final int minInputLength;
  final bool caseSensitive;
}
