import 'package:flutter/widgets.dart';

String _defaultCreateLabel(String input) => 'Add "$input"';

/// {@template autocomplete.creatableConfig}
/// Configures synthetic "create" rows for creatable modes.
///
/// The package never selects arbitrary raw text implicitly. Instead, it
/// renders a create row and calls [createOption] when the row is tapped or,
/// when [createOnSubmit] is `true`, when the input is submitted from the
/// keyboard action button.
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
    this.createOnSubmit = true,
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

  /// Whether submitting the input creates the typed value.
  ///
  /// Submitting means triggering the keyboard action button (the `Ok`/`Done`
  /// key on the on-screen keyboard, or `Enter` on a hardware keyboard), which
  /// Flutter surfaces as `TextField.onSubmitted`.
  ///
  /// When `true`, submitting runs the same create flow as tapping the create
  /// row, including [clearInputOnCreate] and the post-selection popup/focus
  /// behavior from `AutocompleteBehaviorConfig`. Creation is skipped when the
  /// submitted text is not a valid create candidate, for example when it is
  /// shorter than [minInputLength], already matches an option or the current
  /// selection, or is rejected by [shouldShowCreateOption].
  ///
  /// The popup renders the create row only when no regular options are
  /// visible, but submit is not restricted that way: typing text that merely
  /// partially matches options still creates the typed value. Use
  /// [shouldShowCreateOption] to narrow which inputs are creatable at all.
  ///
  /// Set to `false` to keep creation tap-only.
  final bool createOnSubmit;
}
