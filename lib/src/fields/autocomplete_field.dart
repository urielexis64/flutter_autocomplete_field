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
import 'autocomplete_field_configuration.dart';
import 'autocomplete_field_view.dart';

/// Mobile-first autocomplete input with focused constructors per mode.
///
/// The package does not support physical keyboard navigation, desktop-style
/// shortcut handling, or virtualized option lists.
///
/// Every constructor integrates with Flutter forms through `validator`,
/// `onSaved`, and `autovalidateMode`.
class AutocompleteField<T> extends StatelessWidget {
  const AutocompleteField._({
    required AutocompleteFieldConfiguration<T> configuration,
    super.key,
  }) : _configuration = configuration;

  final AutocompleteFieldConfiguration<T> _configuration;

  /// Creates a single-select autocomplete backed by a synchronous option list.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<T?>`.
  ///
  /// ```dart
  /// AutocompleteField.single<String>(
  ///   options: const ['Apple', 'Banana', 'Cherry'],
  ///   getOptionLabel: (option) => option,
  ///   decoration: const InputDecoration(
  ///     labelText: 'Fruit',
  ///     border: OutlineInputBorder(),
  ///   ),
  /// )
  /// ```
  factory AutocompleteField.single({
    Key? key,
    required List<T> options,
    T? value,
    ValueChanged<T?>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<T?>? validator,
    FormFieldSetter<T?>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.single(
        options: options,
        value: value,
        onChanged: onChanged,
        getOptionLabel: getOptionLabel,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates a multiple-select autocomplete that renders selections as chips.
  ///
  /// The field uses an [InputDecorator] plus a wrapping chip/input layout so it
  /// can grow vertically on mobile without overflowing.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<List<T>>`.
  factory AutocompleteField.multiple({
    Key? key,
    required List<T> options,
    List<T> values = const [],
    ValueChanged<List<T>>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(
      closeOnSelect: false,
      clearInputOnSelect: true,
    ),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.multiple(
        options: options,
        values: values,
        onValuesChanged: onChanged,
        getOptionLabel: getOptionLabel,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates an async single-select autocomplete.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<T?>`.
  ///
  /// ```dart
  /// AutocompleteField.async<String>(
  ///   asyncConfig: AutocompleteAsyncConfig(
  ///     optionsBuilder: repository.searchCities,
  ///   ),
  ///   getOptionLabel: (option) => option,
  /// )
  /// ```
  factory AutocompleteField.async({
    Key? key,
    required AutocompleteAsyncConfig<T> asyncConfig,
    T? value,
    ValueChanged<T?>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<T?>? validator,
    FormFieldSetter<T?>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.asyncSingle(
        asyncConfig: asyncConfig,
        value: value,
        onChanged: onChanged,
        getOptionLabel: getOptionLabel,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates an async multiple-select autocomplete.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<List<T>>`.
  factory AutocompleteField.asyncMultiple({
    Key? key,
    required AutocompleteAsyncConfig<T> asyncConfig,
    List<T> values = const [],
    ValueChanged<List<T>>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(
      closeOnSelect: false,
      clearInputOnSelect: true,
    ),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.asyncMultiple(
        asyncConfig: asyncConfig,
        values: values,
        onValuesChanged: onChanged,
        getOptionLabel: getOptionLabel,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates a creatable single-select autocomplete.
  ///
  /// The generic [T] remains the selected value type. When the user taps the
  /// synthetic create row, [AutocompleteCreatableConfig.createOption] converts
  /// the current text input into a new `T`.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<T?>`.
  factory AutocompleteField.creatable({
    Key? key,
    required List<T> options,
    T? value,
    ValueChanged<T?>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    required AutocompleteCreatableConfig<T> creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<T?>? validator,
    FormFieldSetter<T?>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.creatableSingle(
        options: options,
        value: value,
        onChanged: onChanged,
        getOptionLabel: getOptionLabel,
        creatableConfig: creatableConfig,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates a creatable multiple-select autocomplete.
  ///
  /// This constructor supports `Form` validation through
  /// `FormFieldValidator<List<T>>`.
  factory AutocompleteField.creatableMultiple({
    Key? key,
    required List<T> options,
    List<T> values = const [],
    ValueChanged<List<T>>? onChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
    required AutocompleteCreatableConfig<T> creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteBehaviorConfig behaviorConfig =
        const AutocompleteBehaviorConfig(
      closeOnSelect: false,
      clearInputOnSelect: true,
    ),
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompletePopupConfig popupConfig = const AutocompletePopupConfig(),
    AutocompleteClearButtonConfig clearButtonConfig =
        const AutocompleteClearButtonConfig(),
    AutocompleteDropdownButtonConfig dropdownButtonConfig =
        const AutocompleteDropdownButtonConfig(),
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return AutocompleteField._(
      key: key,
      configuration: AutocompleteFieldConfiguration.creatableMultiple(
        options: options,
        values: values,
        onValuesChanged: onChanged,
        getOptionLabel: getOptionLabel,
        creatableConfig: creatableConfig,
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
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_configuration.isMultiple) {
      return FormField<List<T>>(
        key:
            ValueKey<Object>(Object.hashAll(_configuration.values ?? const [])),
        enabled: _configuration.enabled,
        initialValue: List<T>.from(_configuration.values ?? const []),
        validator: _configuration.multipleValidator,
        onSaved: _configuration.multipleOnSaved,
        autovalidateMode: _configuration.autovalidateMode,
        builder: (state) {
          final configuration = _configuration.copyWith(
            values: List<T>.from(state.value ?? const []),
            onValuesChanged: (values) {
              final nextValues = List<T>.unmodifiable(values);
              state.didChange(nextValues);
              _configuration.onValuesChanged?.call(nextValues);
            },
            decoration: _configuration.decoration.copyWith(
              errorText: state.errorText,
            ),
          );
          return AutocompleteFieldView<T>(configuration: configuration);
        },
      );
    }

    return FormField<T>(
      key: ValueKey<Object?>(_configuration.value),
      enabled: _configuration.enabled,
      initialValue: _configuration.value,
      validator: _configuration.singleValidator,
      onSaved: _configuration.singleOnSaved,
      autovalidateMode: _configuration.autovalidateMode,
      builder: (state) {
        final configuration = _configuration.copyWith(
          value: state.value,
          onChanged: (value) {
            state.didChange(value);
            _configuration.onChanged?.call(value);
          },
          decoration: _configuration.decoration.copyWith(
            errorText: state.errorText,
          ),
        );
        return AutocompleteFieldView<T>(configuration: configuration);
      },
    );
  }
}
