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
  const AutocompleteFieldConfiguration._({
    required this.selectionMode,
    required this.getOptionLabel,
    required this.behaviorConfig,
    required this.popupConfig,
    required this.decoration,
    required this.clearButtonConfig,
    required this.dropdownButtonConfig,
    required this.selectionConfig,
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
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
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
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      options: options,
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
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.single,
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
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return AutocompleteFieldConfiguration._(
      selectionMode: AutocompleteSelectionMode.multiple,
      asyncConfig: asyncConfig,
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
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
    required bool enabled,
    required bool readOnly,
    required bool autofocus,
    AutocompleteGroupingConfig<T>? groupingConfig,
    AutocompleteFilterConfig<T>? filterConfig,
    AutocompleteRenderingConfig<T>? renderingConfig,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    TextEditingController? controller,
    FocusNode? focusNode,
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
      chipConfig: chipConfig,
      isOptionEqualToValue: isOptionEqualToValue,
      decoration: decoration,
      controller: controller,
      focusNode: focusNode,
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
  final AutocompleteChipConfig<T>? chipConfig;
  final AutocompleteOptionEquality<T>? isOptionEqualToValue;
  final InputDecoration decoration;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  bool get isMultiple => selectionMode == AutocompleteSelectionMode.multiple;
  bool get isAsync => asyncConfig != null;
  bool get isCreatable => creatableConfig != null;
}
