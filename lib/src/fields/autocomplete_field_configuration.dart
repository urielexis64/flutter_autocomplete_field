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

class AutocompleteFieldConfiguration<T> {
  static const Object _unset = Object();

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
  });

  factory AutocompleteFieldConfiguration.single({
    required List<T> options,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
      options: options,
      creatableConfig: creatableConfig,
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
      singleValidator: validator,
      singleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  factory AutocompleteFieldConfiguration.multiple({
    required List<T> options,
    required List<T> values,
    required ValueChanged<List<T>>? onValuesChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
    AutocompleteCreatableConfig<T>? creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      options: options,
      creatableConfig: creatableConfig,
      values: values,
      onValuesChanged: onValuesChanged,
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
      multipleValidator: validator,
      multipleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  factory AutocompleteFieldConfiguration.asyncSingle({
    required AutocompleteAsyncConfig<T> asyncConfig,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
      asyncConfig: asyncConfig,
      creatableConfig: creatableConfig,
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
      singleValidator: validator,
      singleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  factory AutocompleteFieldConfiguration.asyncMultiple({
    required AutocompleteAsyncConfig<T> asyncConfig,
    required List<T> values,
    required ValueChanged<List<T>>? onValuesChanged,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
    AutocompleteCreatableConfig<T>? creatableConfig,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      asyncConfig: asyncConfig,
      creatableConfig: creatableConfig,
      values: values,
      onValuesChanged: onValuesChanged,
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
      multipleValidator: validator,
      multipleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  factory AutocompleteFieldConfiguration.creatableSingle({
    required List<T> options,
    required AutocompleteCreatableConfig<T> creatableConfig,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
      options: options,
      creatableConfig: creatableConfig,
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
      singleValidator: validator,
      singleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  factory AutocompleteFieldConfiguration.creatableMultiple({
    required List<T> options,
    required List<T> values,
    required ValueChanged<List<T>>? onValuesChanged,
    required AutocompleteCreatableConfig<T> creatableConfig,
    required AutocompleteOptionLabel<T> getOptionLabel,
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
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    FormFieldValidator<List<T>>? validator,
    FormFieldSetter<List<T>>? onSaved,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      options: options,
      values: values,
      onValuesChanged: onValuesChanged,
      creatableConfig: creatableConfig,
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
      multipleValidator: validator,
      multipleOnSaved: onSaved,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }

  final AutocompleteSelectionMode selectionMode;
  final List<T>? options;
  final AutocompleteAsyncConfig<T>? asyncConfig;
  final AutocompleteCreatableConfig<T>? creatableConfig;
  final T? value;
  final List<T>? values;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onValuesChanged;
  final AutocompleteOptionLabel<T> getOptionLabel;
  final AutocompleteGroupingConfig<T>? groupingConfig;
  final AutocompleteBehaviorConfig behaviorConfig;
  final AutocompleteFilterConfig<T>? filterConfig;
  final AutocompleteRenderingConfig<T>? renderingConfig;
  final AutocompletePopupConfig popupConfig;
  final AutocompleteClearButtonConfig clearButtonConfig;
  final AutocompleteDropdownButtonConfig dropdownButtonConfig;
  final AutocompleteSelectionConfig<T> selectionConfig;
  final AutovalidateMode autovalidateMode;
  final AutocompleteChipConfig<T>? chipConfig;
  final AutocompleteOptionEquality<T>? isOptionEqualToValue;
  final InputDecoration decoration;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<T?>? singleValidator;
  final FormFieldValidator<List<T>>? multipleValidator;
  final FormFieldSetter<T?>? singleOnSaved;
  final FormFieldSetter<List<T>>? multipleOnSaved;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  bool get isMultiple => selectionMode == AutocompleteSelectionMode.multiple;
  bool get isAsync => asyncConfig != null;
  bool get isCreatable => creatableConfig != null;

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
    );
  }
}
