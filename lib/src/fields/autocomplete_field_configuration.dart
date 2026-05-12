import 'package:flutter/material.dart';

import '../configs/autocomplete_async_config.dart';
import '../configs/autocomplete_behavior_config.dart';
import '../configs/autocomplete_chip_config.dart';
import '../configs/autocomplete_clear_button_config.dart';
import '../configs/autocomplete_creatable_config.dart';
import '../configs/autocomplete_dropdown_button_config.dart';
import '../configs/autocomplete_filter_config.dart';
import '../configs/autocomplete_grouping_config.dart';
import '../configs/autocomplete_popup_config.dart';
import '../configs/autocomplete_rendering_config.dart';
import '../configs/autocomplete_selection_config.dart';
import '../models/autocomplete_typedefs.dart';
import 'selection_mode.dart';

/// Immutable runtime configuration consumed by [AutocompleteFieldView].
///
/// This object normalizes constructor-specific APIs (`single`, `multiple`,
/// `async`, `asyncMultiple`) into one internal model so rendering and behavior
/// logic can stay centralized.
class AutocompleteFieldConfiguration<T> {
  /// Internal sentinel used by [copyWith] to distinguish omitted from `null`.
  static const Object _unset = Object();

  static String _defaultGetOptionLabel(value) => value.toString();

  /// Creates a normalized configuration snapshot.
  ///
  /// Use one of the mode-specific factories instead of this constructor.
  const AutocompleteFieldConfiguration._({
    required this.selectionMode,
    required this.getOptionLabel,
    required this.behaviorConfig,
    required this.popupConfig,
    required this.decoration,
    required this.clearButtonConfig,
    required this.dropdownButtonConfig,
    required this.selectionConfig,
    required this.autovalidateMode,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    this.options,
    this.asyncConfig,
    this.creatableConfig,
    this.groupingConfig,
    this.filterConfig,
    this.renderingConfig,
    this.chipConfig,
    this.isOptionEqualToValue,
    this.controller,
    this.focusNode,
    this.value,
    this.values,
    this.onChanged,
    this.onValuesChanged,
    this.singleValidator,
    this.multipleValidator,
    this.singleOnSaved,
    this.multipleOnSaved,
    this.isOptionDisabled,
  });

  /// Creates configuration for synchronous single selection.
  factory AutocompleteFieldConfiguration.single({
    required List<T> options,
    required AutocompleteBehaviorConfig behaviorConfig,
    required AutocompletePopupConfig popupConfig,
    required InputDecoration decoration,
    required AutocompleteClearButtonConfig clearButtonConfig,
    required AutocompleteDropdownButtonConfig dropdownButtonConfig,
    required AutocompleteSelectionConfig<T> selectionConfig,
    required AutovalidateMode autovalidateMode,
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteCreatableConfig<T>? creatableConfig,
    T? value,
    ValueChanged<T?>? onChanged,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<T?>? validator,
    FormFieldSetter<T?>? onSaved,
    bool Function(T option)? isOptionDisabled,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
      options: options,
      creatableConfig: creatableConfig,
      value: value,
      onChanged: onChanged,
      getOptionLabel: getOptionLabel ?? _defaultGetOptionLabel,
      groupingConfig: groupingConfig,
      behaviorConfig: behaviorConfig,
      filterConfig: filterConfig,
      renderingConfig: renderingConfig,
      popupConfig: popupConfig,
      clearButtonConfig: clearButtonConfig,
      dropdownButtonConfig: dropdownButtonConfig,
      selectionConfig: selectionConfig,
      autovalidateMode: autovalidateMode,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
      singleValidator: validator,
      singleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      isOptionDisabled: isOptionDisabled,
    );
  }

  /// Creates configuration for synchronous multiple selection.
  factory AutocompleteFieldConfiguration.multiple({
    required List<T> options,
    required List<T> values,
    required ValueChanged<List<T>>? onValuesChanged,
    required AutocompleteBehaviorConfig behaviorConfig,
    required AutocompletePopupConfig popupConfig,
    required AutocompleteChipConfig<T> chipConfig,
    required InputDecoration decoration,
    required AutocompleteClearButtonConfig clearButtonConfig,
    required AutocompleteDropdownButtonConfig dropdownButtonConfig,
    required AutocompleteSelectionConfig<T> selectionConfig,
    required AutovalidateMode autovalidateMode,
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteCreatableConfig<T>? creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
    bool Function(T option)? isOptionDisabled,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      options: options,
      creatableConfig: creatableConfig,
      values: values,
      onValuesChanged: onValuesChanged,
      getOptionLabel: getOptionLabel ?? _defaultGetOptionLabel,
      groupingConfig: groupingConfig,
      behaviorConfig: behaviorConfig,
      filterConfig: filterConfig,
      renderingConfig: renderingConfig,
      popupConfig: popupConfig,
      clearButtonConfig: clearButtonConfig,
      dropdownButtonConfig: dropdownButtonConfig,
      selectionConfig: selectionConfig,
      autovalidateMode: autovalidateMode,
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
      multipleValidator: validator,
      multipleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      isOptionDisabled: isOptionDisabled,
    );
  }

  /// Creates configuration for asynchronous single selection.
  factory AutocompleteFieldConfiguration.asyncSingle({
    required AutocompleteAsyncConfig<T> asyncConfig,
    required AutocompleteBehaviorConfig behaviorConfig,
    required AutocompletePopupConfig popupConfig,
    required InputDecoration decoration,
    required AutocompleteClearButtonConfig clearButtonConfig,
    required AutocompleteDropdownButtonConfig dropdownButtonConfig,
    required AutocompleteSelectionConfig<T> selectionConfig,
    required AutovalidateMode autovalidateMode,
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteCreatableConfig<T>? creatableConfig,
    T? value,
    ValueChanged<T?>? onChanged,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<T?>? validator,
    FormFieldSetter<T?>? onSaved,
    bool Function(T option)? isOptionDisabled,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
      asyncConfig: asyncConfig,
      creatableConfig: creatableConfig,
      value: value,
      onChanged: onChanged,
      getOptionLabel: getOptionLabel ?? _defaultGetOptionLabel,
      groupingConfig: groupingConfig,
      behaviorConfig: behaviorConfig,
      filterConfig: filterConfig,
      renderingConfig: renderingConfig,
      popupConfig: popupConfig,
      clearButtonConfig: clearButtonConfig,
      dropdownButtonConfig: dropdownButtonConfig,
      selectionConfig: selectionConfig,
      autovalidateMode: autovalidateMode,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
      singleValidator: validator,
      singleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      isOptionDisabled: isOptionDisabled,
    );
  }

  /// Creates configuration for asynchronous multiple selection.
  factory AutocompleteFieldConfiguration.asyncMultiple({
    required AutocompleteAsyncConfig<T> asyncConfig,
    required List<T> values,
    required ValueChanged<List<T>>? onValuesChanged,
    required AutocompleteBehaviorConfig behaviorConfig,
    required AutocompletePopupConfig popupConfig,
    required AutocompleteChipConfig<T> chipConfig,
    required InputDecoration decoration,
    required AutocompleteClearButtonConfig clearButtonConfig,
    required AutocompleteDropdownButtonConfig dropdownButtonConfig,
    required AutocompleteSelectionConfig<T> selectionConfig,
    required AutovalidateMode autovalidateMode,
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteCreatableConfig<T>? creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
    bool Function(T option)? isOptionDisabled,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      asyncConfig: asyncConfig,
      creatableConfig: creatableConfig,
      values: values,
      onValuesChanged: onValuesChanged,
      getOptionLabel: getOptionLabel ?? _defaultGetOptionLabel,
      groupingConfig: groupingConfig,
      behaviorConfig: behaviorConfig,
      filterConfig: filterConfig,
      renderingConfig: renderingConfig,
      popupConfig: popupConfig,
      clearButtonConfig: clearButtonConfig,
      dropdownButtonConfig: dropdownButtonConfig,
      selectionConfig: selectionConfig,
      autovalidateMode: autovalidateMode,
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
      multipleValidator: validator,
      multipleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      isOptionDisabled: isOptionDisabled,
    );
  }

  /// Whether the field manages one or many selected values.
  final AutocompleteSelectionMode selectionMode;

  /// Synchronous option source; `null` in async modes.
  final List<T>? options;

  /// Async option source configuration; `null` in synchronous modes.
  final AutocompleteAsyncConfig<T>? asyncConfig;

  /// Optional creatable behavior configuration.
  final AutocompleteCreatableConfig<T>? creatableConfig;

  /// Current single selected value in single mode.
  final T? value;

  /// Current selected values in multiple mode.
  final List<T>? values;

  /// Single-mode selection callback.
  final ValueChanged<T?>? onChanged;

  /// Multiple-mode selection callback.
  final ValueChanged<List<T>>? onValuesChanged;

  /// Label resolver for options and selected values.
  final AutocompleteOptionLabel<T> getOptionLabel;

  /// Optional visual grouping configuration.
  final AutocompleteGroupingConfig<T>? groupingConfig;

  /// Interaction behavior flags.
  final AutocompleteBehaviorConfig behaviorConfig;

  /// Optional text filtering configuration.
  final AutocompleteFilterConfig<T>? filterConfig;

  /// Optional rendering customizations.
  final AutocompleteRenderingConfig<T>? renderingConfig;

  /// Popup style/layout configuration.
  final AutocompletePopupConfig popupConfig;

  /// Clear-button appearance and visibility rules.
  final AutocompleteClearButtonConfig clearButtonConfig;

  /// Dropdown indicator button appearance and visibility rules.
  final AutocompleteDropdownButtonConfig dropdownButtonConfig;

  /// Selection indicator and selected-option visibility behavior.
  final AutocompleteSelectionConfig<T> selectionConfig;

  /// Flutter form autovalidation policy.
  final AutovalidateMode autovalidateMode;

  /// Multiple-mode chip presentation configuration.
  final AutocompleteChipConfig<T>? chipConfig;

  /// Optional custom equality between options and selected values.
  final AutocompleteOptionEquality<T>? isOptionEqualToValue;

  /// Base field decoration.
  final InputDecoration decoration;

  /// Optional externally managed text controller.
  final TextEditingController? controller;

  /// Optional externally managed focus node.
  final FocusNode? focusNode;

  /// Single-mode validator for form integration.
  final FormFieldValidator<T?>? singleValidator;

  /// Multiple-mode validator for form integration.
  final FormFieldValidator<List<T>>? multipleValidator;

  /// Single-mode onSaved callback for form integration.
  final FormFieldSetter<T?>? singleOnSaved;

  /// Multiple-mode onSaved callback for form integration.
  final FormFieldSetter<List<T>>? multipleOnSaved;

  /// Whether field interactions are enabled.
  final bool enabled;

  /// Whether text editing is disabled while still allowing focus.
  final bool readOnly;

  /// Whether the field should request focus on mount.
  final bool autofocus;

  /// Optional callback that marks specific options as disabled.
  final bool Function(T option)? isOptionDisabled;

  /// Whether this configuration is for multiple selection.
  bool get isMultiple => selectionMode == AutocompleteSelectionMode.multiple;

  /// Whether options are loaded asynchronously.
  bool get isAsync => asyncConfig != null;

  /// Whether synthetic create-option behavior is enabled.
  bool get isCreatable => creatableConfig != null;

  /// Creates a copy overriding mutable runtime values.
  ///
  /// This is primarily used by `FormField` wrappers to inject current value and
  /// validation error text without mutating the original configuration.
  AutocompleteFieldConfiguration<T> copyWith({
    Object? value = _unset,
    Object? values = _unset,
    ValueChanged<T?>? onChanged,
    ValueChanged<List<T>>? onValuesChanged,
    InputDecoration? decoration,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: selectionMode,
      getOptionLabel: getOptionLabel,
      behaviorConfig: behaviorConfig,
      popupConfig: popupConfig,
      decoration: decoration ?? this.decoration,
      clearButtonConfig: clearButtonConfig,
      dropdownButtonConfig: dropdownButtonConfig,
      selectionConfig: selectionConfig,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      options: options,
      asyncConfig: asyncConfig,
      creatableConfig: creatableConfig,
      groupingConfig: groupingConfig,
      filterConfig: filterConfig,
      renderingConfig: renderingConfig,
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      controller: controller,
      focusNode: focusNode,
      value: identical(value, _unset) ? this.value : value as T?,
      values: identical(values, _unset) ? this.values : values as List<T>?,
      onChanged: onChanged ?? this.onChanged,
      onValuesChanged: onValuesChanged ?? this.onValuesChanged,
      singleValidator: singleValidator,
      multipleValidator: multipleValidator,
      singleOnSaved: singleOnSaved,
      multipleOnSaved: multipleOnSaved,
      isOptionDisabled: isOptionDisabled,
    );
  }
}
