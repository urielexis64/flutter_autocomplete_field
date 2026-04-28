import 'package:flutter/material.dart';

import '../configs/autocomplete_async_config.dart';
import '../configs/autocomplete_behavior_config.dart';
import '../configs/autocomplete_chip_config.dart';
import '../configs/autocomplete_clear_button_config.dart';
import '../configs/autocomplete_creatable_config.dart';
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
class AutocompleteField<T> extends StatelessWidget {
  const AutocompleteField._({
    required AutocompleteFieldConfiguration<T> configuration,
    super.key,
  }) : _configuration = configuration;

  final AutocompleteFieldConfiguration<T> _configuration;

  /// Creates a single-select autocomplete backed by a synchronous option list.
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        chipConfig: chipConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates an async single-select autocomplete.
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates an async multiple-select autocomplete.
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        chipConfig: chipConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  /// Creates a creatable multiple-select autocomplete.
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
    AutocompleteSelectionConfig<T> selectionConfig =
        const AutocompleteSelectionConfig(),
    AutocompleteChipConfig<T> chipConfig = const AutocompleteChipConfig(),
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    InputDecoration decoration = const InputDecoration(),
    TextEditingController? controller,
    FocusNode? focusNode,
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
        selectionConfig: selectionConfig,
        chipConfig: chipConfig,
        isOptionEqualToValue: isOptionEqualToValue,
        decoration: decoration,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutocompleteFieldView<T>(configuration: _configuration);
  }
}
