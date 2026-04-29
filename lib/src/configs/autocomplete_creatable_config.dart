import 'package:flutter/widgets.dart';

String _defaultCreateLabel(String input) => 'Add "$input"';

/// {@template autocomplete.creatableConfig}
/// Configures synthetic "create" rows for creatable modes.
///
/// The package never selects arbitrary raw text. Instead, it renders a create
/// row and calls [createOption] when the row is tapped.
/// {@endtemplate}
class AutocompleteCreatableConfig<T> {
  /// Creates a creatable configuration.
  ///
  /// Throws an [AssertionError] when [minInputLength] is negative.
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

  /// Converts user input into a typed value [T].
  ///
  /// This callback is required and should avoid throwing for expected user
  /// input values.
  final T Function(String input) createOption;

  /// Builds the create-row label shown in the popup.
  ///
  /// Defaults to `Add "<input>"`.
  final String Function(String input)? createLabel;

  /// Optional gate for whether the create row should be shown.
  ///
  /// Return `false` to suppress create behavior for specific inputs.
  final bool Function(String input, List<T> options)? shouldShowCreateOption;

  /// Optional custom matcher used to compare input against existing options.
  ///
  /// When null, matching uses [trimInput] and [caseSensitive].
  final bool Function(
    String input,
    T option,
    String Function(T option) getOptionLabel,
  )? optionMatchesInput;

  /// Optional custom UI for the create row.
  final Widget Function(BuildContext context, String input)?
      createOptionBuilder;

  /// Clears the query input after creating and selecting a new value.
  final bool clearInputOnCreate;

  /// Whether input and labels are trimmed before comparison checks.
  final bool trimInput;

  /// Minimum number of input characters required before create row is shown.
  final int minInputLength;

  /// Whether input matching treats case differences as distinct.
  final bool caseSensitive;
}
