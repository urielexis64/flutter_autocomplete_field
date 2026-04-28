import 'dart:async';

import 'package:flutter/material.dart';

import 'autocomplete_chip.dart';
import 'autocomplete_controller.dart';
import 'autocomplete_filter.dart';
import 'autocomplete_popup.dart';
import 'autocomplete_theme.dart';
import 'autocomplete_types.dart';

/// A reusable Flutter autocomplete text field inspired by MUI Autocomplete.
///
/// The widget is a normal text input enhanced by a suggested-options panel. It
/// supports combo-box mode, where values come from [options], and free-solo
/// mode, where typed text can be committed for string-compatible values.
class AutocompleteField<T> extends StatefulWidget {
  /// Creates an autocomplete field.
  const AutocompleteField({
    super.key,
    this.options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    this.getOptionKey,
    this.isOptionEqualToValue,
    this.getOptionDisabled,
    this.getSelectedItemDisabled,
    this.groupBy,
    this.filterOptions,
    this.filterSelectedOptions = false,
    this.value,
    this.values,
    this.inputValue = '',
    this.defaultValue,
    this.defaultValues,
    this.multiple = false,
    this.freeSolo = false,
    this.disabled = false,
    this.readOnly = false,
    this.loading = false,
    this.loadingText = 'Loading...',
    this.noOptionsText = 'No options',
    this.onChanged,
    this.onValuesChanged,
    this.onInputChanged,
    this.onOpen,
    this.onClose,
    this.asyncOptionsBuilder,
    this.loadOptionsOnOpen,
    this.optionBuilder,
    this.groupBuilder,
    this.stickyGroupHeaders = true,
    this.groupHeaderHeight = 32,
    this.selectedItemBuilder,
    this.chipBuilder,
    this.selectedItemsBuilder,
    this.chipLayout = AutocompleteChipLayout.wrap,
    this.chipMinInputWidth = 96,
    this.chipMaxWidth,
    this.chipSpacing,
    this.chipRunSpacing,
    this.chipContainerPadding = EdgeInsets.zero,
    this.chipBackgroundColor,
    this.chipTextStyle,
    this.chipDeleteIcon,
    this.chipShape,
    this.chipSide,
    this.chipLabelPadding,
    this.chipElevation,
    this.chipLabelMaxWidth = 160,
    this.decoration = const InputDecoration(),
    this.prefixIcon,
    this.suffixIcon,
    this.clearIcon,
    this.dropdownIcon,
    this.theme,
    this.popupMaxHeight,
    this.popupWidth,
    this.fullWidth = true,
    this.size = AutocompleteSize.medium,
    this.disableClearable = false,
    this.clearOnEscape = false,
    this.openOnFocus = false,
    this.autoHighlight = false,
    this.autoSelect = false,
    this.disableCloseOnSelect = false,
    this.includeInputInList = false,
    this.disableListWrap = false,
    this.blurOnSelect = false,
    this.clearOnBlur = false,
    this.selectOnFocus = false,
    this.handleHomeEndKeys = true,
    this.limitTags,
    this.virtualized = false,
  }) : getOptionLabel = getOptionLabel ?? defaultAutocompleteOptionLabel<T>;

  /// Creates a single-value combo box where values come from [options].
  ///
  /// This focused constructor omits multiple-selection and free-solo fields so
  /// callers do not accidentally combine incompatible value models.
  factory AutocompleteField.comboBox({
    Key? key,
    List<T> options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteOptionGroupBy<T>? groupBy,
    AutocompleteFilterCallback<T>? filterOptions,
    bool filterSelectedOptions = false,
    T? value,
    String inputValue = '',
    T? defaultValue,
    bool disabled = false,
    bool readOnly = false,
    bool loading = false,
    String? loadingText = 'Loading...',
    String? noOptionsText = 'No options',
    ValueChanged<T?>? onChanged,
    ValueChanged<String>? onInputChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    AutocompleteOptionBuilder<T>? optionBuilder,
    AutocompleteGroupBuilder? groupBuilder,
    bool stickyGroupHeaders = true,
    double groupHeaderHeight = 32,
    AutocompleteSelectedItemBuilder<T>? selectedItemBuilder,
    InputDecoration decoration = const InputDecoration(),
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? clearIcon,
    Widget? dropdownIcon,
    AutocompleteThemeData? theme,
    double? popupMaxHeight,
    double? popupWidth,
    bool fullWidth = true,
    AutocompleteSize size = AutocompleteSize.medium,
    bool disableClearable = false,
    bool clearOnEscape = false,
    bool openOnFocus = false,
    bool autoHighlight = false,
    bool autoSelect = false,
    bool includeInputInList = false,
    bool disableListWrap = false,
    bool blurOnSelect = false,
    bool clearOnBlur = false,
    bool selectOnFocus = false,
    bool handleHomeEndKeys = true,
    bool virtualized = false,
  }) {
    return AutocompleteField<T>(
      key: key,
      options: options,
      getOptionLabel: getOptionLabel,
      getOptionKey: getOptionKey,
      isOptionEqualToValue: isOptionEqualToValue,
      getOptionDisabled: getOptionDisabled,
      groupBy: groupBy,
      filterOptions: filterOptions,
      filterSelectedOptions: filterSelectedOptions,
      value: value,
      inputValue: inputValue,
      defaultValue: defaultValue,
      disabled: disabled,
      readOnly: readOnly,
      loading: loading,
      loadingText: loadingText,
      noOptionsText: noOptionsText,
      onChanged: onChanged,
      onInputChanged: onInputChanged,
      onOpen: onOpen,
      onClose: onClose,
      optionBuilder: optionBuilder,
      groupBuilder: groupBuilder,
      stickyGroupHeaders: stickyGroupHeaders,
      groupHeaderHeight: groupHeaderHeight,
      selectedItemBuilder: selectedItemBuilder,
      decoration: decoration,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      clearIcon: clearIcon,
      dropdownIcon: dropdownIcon,
      theme: theme,
      popupMaxHeight: popupMaxHeight,
      popupWidth: popupWidth,
      fullWidth: fullWidth,
      size: size,
      disableClearable: disableClearable,
      clearOnEscape: clearOnEscape,
      openOnFocus: openOnFocus,
      autoHighlight: autoHighlight,
      autoSelect: autoSelect,
      includeInputInList: includeInputInList,
      disableListWrap: disableListWrap,
      blurOnSelect: blurOnSelect,
      clearOnBlur: clearOnBlur,
      selectOnFocus: selectOnFocus,
      handleHomeEndKeys: handleHomeEndKeys,
      virtualized: virtualized,
    );
  }

  /// Creates a multiple-selection autocomplete with chips/tags.
  ///
  /// This constructor exposes `values`/`onValuesChanged` and omits single-value
  /// `value`/`onChanged` fields.
  factory AutocompleteField.multiple({
    Key? key,
    List<T> options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteOptionDisabled<T>? getSelectedItemDisabled,
    AutocompleteOptionGroupBy<T>? groupBy,
    AutocompleteFilterCallback<T>? filterOptions,
    bool filterSelectedOptions = false,
    List<T>? values,
    String inputValue = '',
    List<T>? defaultValues,
    bool disabled = false,
    bool readOnly = false,
    bool loading = false,
    String? loadingText = 'Loading...',
    String? noOptionsText = 'No options',
    ValueChanged<List<T>>? onValuesChanged,
    ValueChanged<String>? onInputChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    AutocompleteOptionBuilder<T>? optionBuilder,
    AutocompleteGroupBuilder? groupBuilder,
    bool stickyGroupHeaders = true,
    double groupHeaderHeight = 32,
    AutocompleteSelectedItemBuilder<T>? selectedItemBuilder,
    AutocompleteChipBuilder<T>? chipBuilder,
    AutocompleteSelectedItemsBuilder<T>? selectedItemsBuilder,
    AutocompleteChipLayout chipLayout = AutocompleteChipLayout.wrap,
    double chipMinInputWidth = 96,
    double? chipMaxWidth,
    double? chipSpacing,
    double? chipRunSpacing,
    EdgeInsetsGeometry chipContainerPadding = EdgeInsets.zero,
    Color? chipBackgroundColor,
    TextStyle? chipTextStyle,
    Widget? chipDeleteIcon,
    OutlinedBorder? chipShape,
    BorderSide? chipSide,
    EdgeInsetsGeometry? chipLabelPadding,
    double? chipElevation,
    double? chipLabelMaxWidth = 160,
    InputDecoration decoration = const InputDecoration(),
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? clearIcon,
    Widget? dropdownIcon,
    AutocompleteThemeData? theme,
    double? popupMaxHeight,
    double? popupWidth,
    bool fullWidth = true,
    AutocompleteSize size = AutocompleteSize.medium,
    bool disableClearable = false,
    bool clearOnEscape = false,
    bool openOnFocus = false,
    bool autoHighlight = false,
    bool disableCloseOnSelect = false,
    bool includeInputInList = false,
    bool disableListWrap = false,
    bool blurOnSelect = false,
    bool selectOnFocus = false,
    bool handleHomeEndKeys = true,
    int? limitTags,
    bool virtualized = false,
  }) {
    return AutocompleteField<T>(
      key: key,
      options: options,
      getOptionLabel: getOptionLabel,
      getOptionKey: getOptionKey,
      isOptionEqualToValue: isOptionEqualToValue,
      getOptionDisabled: getOptionDisabled,
      getSelectedItemDisabled: getSelectedItemDisabled,
      groupBy: groupBy,
      filterOptions: filterOptions,
      filterSelectedOptions: filterSelectedOptions,
      values: values,
      inputValue: inputValue,
      defaultValues: defaultValues,
      multiple: true,
      disabled: disabled,
      readOnly: readOnly,
      loading: loading,
      loadingText: loadingText,
      noOptionsText: noOptionsText,
      onValuesChanged: onValuesChanged,
      onInputChanged: onInputChanged,
      onOpen: onOpen,
      onClose: onClose,
      optionBuilder: optionBuilder,
      groupBuilder: groupBuilder,
      stickyGroupHeaders: stickyGroupHeaders,
      groupHeaderHeight: groupHeaderHeight,
      selectedItemBuilder: selectedItemBuilder,
      chipBuilder: chipBuilder,
      selectedItemsBuilder: selectedItemsBuilder,
      chipLayout: chipLayout,
      chipMinInputWidth: chipMinInputWidth,
      chipMaxWidth: chipMaxWidth,
      chipSpacing: chipSpacing,
      chipRunSpacing: chipRunSpacing,
      chipContainerPadding: chipContainerPadding,
      chipBackgroundColor: chipBackgroundColor,
      chipTextStyle: chipTextStyle,
      chipDeleteIcon: chipDeleteIcon,
      chipShape: chipShape,
      chipSide: chipSide,
      chipLabelPadding: chipLabelPadding,
      chipElevation: chipElevation,
      chipLabelMaxWidth: chipLabelMaxWidth,
      decoration: decoration,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      clearIcon: clearIcon,
      dropdownIcon: dropdownIcon,
      theme: theme,
      popupMaxHeight: popupMaxHeight,
      popupWidth: popupWidth,
      fullWidth: fullWidth,
      size: size,
      disableClearable: disableClearable,
      clearOnEscape: clearOnEscape,
      openOnFocus: openOnFocus,
      autoHighlight: autoHighlight,
      disableCloseOnSelect: disableCloseOnSelect,
      includeInputInList: includeInputInList,
      disableListWrap: disableListWrap,
      blurOnSelect: blurOnSelect,
      selectOnFocus: selectOnFocus,
      handleHomeEndKeys: handleHomeEndKeys,
      limitTags: limitTags,
      virtualized: virtualized,
    );
  }

  /// Creates a free-solo autocomplete for arbitrary text entry.
  ///
  /// Prefer `AutocompleteField<String>.freeSolo` so typed text can be committed
  /// as a string value.
  factory AutocompleteField.freeSolo({
    Key? key,
    List<T> options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteFilterCallback<T>? filterOptions,
    T? value,
    String inputValue = '',
    T? defaultValue,
    bool disabled = false,
    bool readOnly = false,
    bool loading = false,
    String? loadingText = 'Loading...',
    String? noOptionsText = 'No options',
    ValueChanged<T?>? onChanged,
    ValueChanged<String>? onInputChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    AutocompleteAsyncOptionsBuilder<T>? asyncOptionsBuilder,
    AutocompleteOptionBuilder<T>? optionBuilder,
    AutocompleteSelectedItemBuilder<T>? selectedItemBuilder,
    InputDecoration decoration = const InputDecoration(),
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? clearIcon,
    Widget? dropdownIcon,
    AutocompleteThemeData? theme,
    double? popupMaxHeight,
    double? popupWidth,
    bool fullWidth = true,
    AutocompleteSize size = AutocompleteSize.medium,
    bool disableClearable = false,
    bool clearOnEscape = false,
    bool openOnFocus = false,
    bool autoHighlight = false,
    bool autoSelect = false,
    bool includeInputInList = false,
    bool disableListWrap = false,
    bool blurOnSelect = false,
    bool clearOnBlur = false,
    bool selectOnFocus = false,
    bool handleHomeEndKeys = true,
    bool virtualized = false,
  }) {
    return AutocompleteField<T>(
      key: key,
      options: options,
      getOptionLabel: getOptionLabel,
      getOptionKey: getOptionKey,
      isOptionEqualToValue: isOptionEqualToValue,
      getOptionDisabled: getOptionDisabled,
      filterOptions: filterOptions,
      value: value,
      inputValue: inputValue,
      defaultValue: defaultValue,
      freeSolo: true,
      disabled: disabled,
      readOnly: readOnly,
      loading: loading,
      loadingText: loadingText,
      noOptionsText: noOptionsText,
      onChanged: onChanged,
      onInputChanged: onInputChanged,
      onOpen: onOpen,
      onClose: onClose,
      asyncOptionsBuilder: asyncOptionsBuilder,
      optionBuilder: optionBuilder,
      selectedItemBuilder: selectedItemBuilder,
      decoration: decoration,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      clearIcon: clearIcon,
      dropdownIcon: dropdownIcon,
      theme: theme,
      popupMaxHeight: popupMaxHeight,
      popupWidth: popupWidth,
      fullWidth: fullWidth,
      size: size,
      disableClearable: disableClearable,
      clearOnEscape: clearOnEscape,
      openOnFocus: openOnFocus,
      autoHighlight: autoHighlight,
      autoSelect: autoSelect,
      includeInputInList: includeInputInList,
      disableListWrap: disableListWrap,
      blurOnSelect: blurOnSelect,
      clearOnBlur: clearOnBlur,
      selectOnFocus: selectOnFocus,
      handleHomeEndKeys: handleHomeEndKeys,
      virtualized: virtualized,
    );
  }

  /// Creates an async single-value autocomplete.
  ///
  /// Use [loadOptionsOnOpen] for load-on-open behavior or
  /// [asyncOptionsBuilder] for search-as-you-type behavior.
  factory AutocompleteField.async({
    Key? key,
    List<T> options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteFilterCallback<T>? filterOptions,
    T? value,
    String inputValue = '',
    T? defaultValue,
    bool freeSolo = false,
    bool disabled = false,
    bool readOnly = false,
    bool loading = false,
    String? loadingText = 'Loading...',
    String? noOptionsText = 'No options',
    ValueChanged<T?>? onChanged,
    ValueChanged<String>? onInputChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    AutocompleteAsyncOptionsBuilder<T>? asyncOptionsBuilder,
    AutocompleteLoadOptionsOnOpen<T>? loadOptionsOnOpen,
    AutocompleteOptionBuilder<T>? optionBuilder,
    InputDecoration decoration = const InputDecoration(),
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? clearIcon,
    Widget? dropdownIcon,
    AutocompleteThemeData? theme,
    double? popupMaxHeight,
    double? popupWidth,
    bool fullWidth = true,
    AutocompleteSize size = AutocompleteSize.medium,
    bool disableClearable = false,
    bool clearOnEscape = false,
    bool openOnFocus = false,
    bool autoHighlight = false,
    bool autoSelect = false,
    bool includeInputInList = false,
    bool disableListWrap = false,
    bool blurOnSelect = false,
    bool clearOnBlur = false,
    bool selectOnFocus = false,
    bool handleHomeEndKeys = true,
    bool virtualized = false,
  }) {
    return AutocompleteField<T>(
      key: key,
      options: options,
      getOptionLabel: getOptionLabel,
      getOptionKey: getOptionKey,
      isOptionEqualToValue: isOptionEqualToValue,
      getOptionDisabled: getOptionDisabled,
      filterOptions: filterOptions,
      value: value,
      inputValue: inputValue,
      defaultValue: defaultValue,
      freeSolo: freeSolo,
      disabled: disabled,
      readOnly: readOnly,
      loading: loading,
      loadingText: loadingText,
      noOptionsText: noOptionsText,
      onChanged: onChanged,
      onInputChanged: onInputChanged,
      onOpen: onOpen,
      onClose: onClose,
      asyncOptionsBuilder: asyncOptionsBuilder,
      loadOptionsOnOpen: loadOptionsOnOpen,
      optionBuilder: optionBuilder,
      decoration: decoration,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      clearIcon: clearIcon,
      dropdownIcon: dropdownIcon,
      theme: theme,
      popupMaxHeight: popupMaxHeight,
      popupWidth: popupWidth,
      fullWidth: fullWidth,
      size: size,
      disableClearable: disableClearable,
      clearOnEscape: clearOnEscape,
      openOnFocus: openOnFocus,
      autoHighlight: autoHighlight,
      autoSelect: autoSelect,
      includeInputInList: includeInputInList,
      disableListWrap: disableListWrap,
      blurOnSelect: blurOnSelect,
      clearOnBlur: clearOnBlur,
      selectOnFocus: selectOnFocus,
      handleHomeEndKeys: handleHomeEndKeys,
      virtualized: virtualized,
    );
  }

  /// Candidate options. In combo-box mode selected values should come from here.
  final List<T> options;

  /// Converts an option into display text.
  final AutocompleteOptionLabel<T> getOptionLabel;

  /// Returns a stable key for an option with potentially duplicate labels.
  final AutocompleteOptionKey<T>? getOptionKey;

  /// Compares an option to a value.
  ///
  /// MUI calls out that object options should provide custom equality because
  /// strict identity is often not the intended selection behavior.
  final AutocompleteOptionEquality<T>? isOptionEqualToValue;

  /// Returns whether an option should be visible but not selectable.
  final AutocompleteOptionDisabled<T>? getOptionDisabled;

  /// Returns whether a selected chip is fixed and cannot be removed.
  final AutocompleteOptionDisabled<T>? getSelectedItemDisabled;

  /// Returns the group header for an option.
  ///
  /// Matching groups are coalesced across the filtered option list. MUI notes
  /// that grouped options should be sorted by this same dimension; this widget
  /// does not require sorting to avoid duplicate headers.
  final AutocompleteOptionGroupBy<T>? groupBy;

  /// Custom filter callback.
  ///
  /// Use [identityAutocompleteFilter] for server-side filtering so the built-in
  /// client filter does not discard already-filtered async results.
  final AutocompleteFilterCallback<T>? filterOptions;

  /// Whether selected values should be hidden from the popup.
  final bool filterSelectedOptions;

  /// Controlled single selected value.
  final T? value;

  /// Controlled selected values for [multiple] mode.
  final List<T>? values;

  /// Controlled input text.
  final String inputValue;

  /// Initial selected value for uncontrolled single mode.
  final T? defaultValue;

  /// Initial selected values for uncontrolled multiple mode.
  final List<T>? defaultValues;

  /// Whether multiple options can be selected.
  final bool multiple;

  /// Whether arbitrary typed text can be committed as a value.
  final bool freeSolo;

  /// Whether the whole field is disabled.
  final bool disabled;

  /// Whether text editing and selection changes are blocked.
  final bool readOnly;

  /// External loading flag.
  final bool loading;

  /// Text shown while loading and no options are available.
  final String? loadingText;

  /// Text shown when no options match.
  final String? noOptionsText;

  /// Called when the single selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Called when selected values change in [multiple] mode.
  final ValueChanged<List<T>>? onValuesChanged;

  /// Called when input text changes.
  final ValueChanged<String>? onInputChanged;

  /// Called when the popup opens.
  final VoidCallback? onOpen;

  /// Called when the popup closes.
  final VoidCallback? onClose;

  /// Loads options for each query.
  final AutocompleteAsyncOptionsBuilder<T>? asyncOptionsBuilder;

  /// Loads options the first time the popup opens.
  final AutocompleteLoadOptionsOnOpen<T>? loadOptionsOnOpen;

  /// Builds custom option rows.
  final AutocompleteOptionBuilder<T>? optionBuilder;

  /// Builds custom grouped headers.
  ///
  /// When [stickyGroupHeaders] is true, this builder is used for the pinned
  /// header and receives an empty children list. Return only header content in
  /// that case. When sticky headers are disabled, it receives the option row
  /// children and can render a whole grouped section.
  final AutocompleteGroupBuilder? groupBuilder;

  /// Whether grouped option headers stay pinned while the popup scrolls.
  final bool stickyGroupHeaders;

  /// Height reserved for grouped headers.
  final double groupHeaderHeight;

  /// Builds a custom widget for a selected single value.
  final AutocompleteSelectedItemBuilder<T>? selectedItemBuilder;

  /// Builds an individual selected chip in multiple mode.
  ///
  /// This is more specific than [selectedItemBuilder] and takes precedence for
  /// multiple chips when both are provided.
  final AutocompleteChipBuilder<T>? chipBuilder;

  /// Builds a custom widget for selected multiple values.
  final AutocompleteSelectedItemsBuilder<T>? selectedItemsBuilder;

  /// Layout strategy for selected chips in multiple mode.
  final AutocompleteChipLayout chipLayout;

  /// Minimum horizontal space reserved for the text input after chips.
  ///
  /// This prevents chips from consuming the area used to focus and type.
  final double chipMinInputWidth;

  /// Optional maximum width for the chip area before the suffix buttons.
  final double? chipMaxWidth;

  /// Horizontal spacing between chips.
  final double? chipSpacing;

  /// Vertical spacing between chip runs in wrapped layout.
  final double? chipRunSpacing;

  /// Padding around the selected chip collection.
  final EdgeInsetsGeometry chipContainerPadding;

  /// Background color for default chips.
  final Color? chipBackgroundColor;

  /// Text style for default chip labels.
  final TextStyle? chipTextStyle;

  /// Delete icon for default chips.
  final Widget? chipDeleteIcon;

  /// Shape for default chips.
  final OutlinedBorder? chipShape;

  /// Border side for default chips.
  final BorderSide? chipSide;

  /// Label padding for default chips.
  final EdgeInsetsGeometry? chipLabelPadding;

  /// Elevation for default chips.
  final double? chipElevation;

  /// Maximum width for default chip label text.
  final double? chipLabelMaxWidth;

  /// Text field decoration.
  final InputDecoration decoration;

  /// Optional prefix icon.
  final Widget? prefixIcon;

  /// Optional suffix icon.
  final Widget? suffixIcon;

  /// Optional clear icon.
  final Widget? clearIcon;

  /// Optional popup toggle icon.
  final Widget? dropdownIcon;

  /// Local autocomplete theme override.
  final AutocompleteThemeData? theme;

  /// Maximum popup height.
  final double? popupMaxHeight;

  /// Popup width. Defaults to the field width.
  final double? popupWidth;

  /// Whether the field should expand horizontally.
  final bool fullWidth;

  /// Size variant for field density, options, and chips.
  final AutocompleteSize size;

  /// Whether the clear button is hidden and clear actions are blocked.
  final bool disableClearable;

  /// Whether Escape clears value and input in addition to closing the popup.
  final bool clearOnEscape;

  /// Whether focusing the field opens the popup.
  final bool openOnFocus;

  /// Whether the first enabled option is highlighted when the popup opens.
  final bool autoHighlight;

  /// Whether blur or Tab commits the highlighted option.
  final bool autoSelect;

  /// Whether selecting an option keeps the popup open.
  final bool disableCloseOnSelect;

  /// Whether keyboard navigation may include the input as a non-option stop.
  final bool includeInputInList;

  /// Whether ArrowUp/ArrowDown should stop at the list edges.
  final bool disableListWrap;

  /// Whether the field should lose focus after selecting an option.
  final bool blurOnSelect;

  /// Whether blur clears uncommitted input text.
  final bool clearOnBlur;

  /// Whether focus selects all input text.
  final bool selectOnFocus;

  /// Whether Home/End move the highlighted option.
  final bool handleHomeEndKeys;

  /// Maximum displayed tags while the field is not focused.
  final int? limitTags;

  /// Whether the popup should use builder-based virtualization.
  final bool virtualized;

  @override
  State<AutocompleteField<T>> createState() => _AutocompleteFieldState<T>();
}

class _AutocompleteFieldState<T> extends State<AutocompleteField<T>> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late AutocompleteController<T> _controller;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _overlayInserted = false;
  bool _updatingText = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _textController = TextEditingController(text: _controller.inputValue);
    _focusNode = FocusNode();
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AutocompleteField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.updateConfiguration(
      options: widget.options,
      getOptionLabel: widget.getOptionLabel,
      getOptionKey: widget.getOptionKey,
      isOptionEqualToValue: widget.isOptionEqualToValue,
      getOptionDisabled: widget.getOptionDisabled,
      getSelectedItemDisabled: widget.getSelectedItemDisabled,
      filterOptions: widget.filterOptions ?? createAutocompleteFilter<T>(),
      multiple: widget.multiple,
      freeSolo: widget.freeSolo,
      filterSelectedOptions: widget.filterSelectedOptions,
      asyncOptionsBuilder: widget.asyncOptionsBuilder,
      loadOptionsOnOpen: widget.loadOptionsOnOpen,
    );
    if (oldWidget.value != widget.value) {
      _controller.setValue(widget.value);
    }
    if (oldWidget.values != widget.values && widget.values != null) {
      _controller.setValues(widget.values!);
    }
    if (oldWidget.inputValue != widget.inputValue) {
      _controller.setInputValue(
        widget.inputValue,
        reason: AutocompleteInputChangedReason.reset,
      );
    }
    _syncTextController();
    _syncOverlay();
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AutocompleteThemeData.resolve(
      Theme.of(context),
      widget.theme,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : null;
        final effectiveDecoration = _effectiveDecoration(theme, fieldWidth);

        final textField = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (!widget.disabled && !widget.readOnly) {
              _focusNode.requestFocus();
              _handleInputTap();
            }
          },
          child: InputDecorator(
            decoration: effectiveDecoration,
            isEmpty:
                _visibleSelectedValues().isEmpty &&
                _textController.text.isEmpty,
            isFocused: _hasFocus,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ?_buildSelectedPrefix(theme, fieldWidth),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    maxWidth: 240,
                  ),
                  child: IntrinsicWidth(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      key: const ValueKey<String>('autocomplete-input'),
                      controller: _textController,
                      focusNode: _focusNode,
                      enabled: !widget.disabled,
                      readOnly: widget.readOnly,
                      onChanged: _handleInputChanged,
                      onTap: _handleInputTap,
                      style: widget.size == AutocompleteSize.small
                          ? Theme.of(context).textTheme.bodyMedium
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return Semantics(
          textField: true,
          enabled: !widget.disabled,
          label: widget.decoration.labelText,
          hint: _controller.isOpen ? 'Expanded' : 'Collapsed',
          child: CompositedTransformTarget(
            link: _layerLink,
            child: SizedBox(
              key: _fieldKey,
              width: widget.fullWidth ? double.infinity : null,
              child: textField,
            ),
          ),
        );
      },
    );
  }

  AutocompleteController<T> _createController() {
    return AutocompleteController<T>(
      options: widget.options,
      getOptionLabel: widget.getOptionLabel,
      getOptionKey: widget.getOptionKey,
      isOptionEqualToValue: widget.isOptionEqualToValue,
      getOptionDisabled: widget.getOptionDisabled,
      getSelectedItemDisabled: widget.getSelectedItemDisabled,
      filterOptions: widget.filterOptions ?? createAutocompleteFilter<T>(),
      value: widget.value,
      values: widget.values,
      defaultValue: widget.defaultValue,
      defaultValues: widget.defaultValues,
      inputValue: widget.inputValue,
      multiple: widget.multiple,
      freeSolo: widget.freeSolo,
      filterSelectedOptions: widget.filterSelectedOptions,
      asyncOptionsBuilder: widget.asyncOptionsBuilder,
      loadOptionsOnOpen: widget.loadOptionsOnOpen,
    );
  }

  InputDecoration _effectiveDecoration(
    AutocompleteThemeData theme,
    double? fieldWidth,
  ) {
    final isSmall = widget.size == AutocompleteSize.small;
    final suffix = _buildSuffix();
    return widget.decoration.copyWith(
      isDense: widget.decoration.isDense ?? isSmall,
      prefixIcon: widget.prefixIcon ?? widget.decoration.prefixIcon,
      prefix: widget.decoration.prefix,
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      contentPadding:
          widget.decoration.contentPadding ??
          (isSmall
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              : null),
    );
  }

  Widget? _buildSelectedPrefix(
    AutocompleteThemeData theme,
    double? fieldWidth,
  ) {
    if (widget.multiple) {
      final selectedValues = _visibleSelectedValues();
      final hiddenCount = _hiddenSelectedCount();
      if (selectedValues.isEmpty && hiddenCount == 0) {
        return null;
      }
      final state = AutocompleteSelectedItemsState(
        focused: _hasFocus,
        limitTags: widget.limitTags,
        hiddenCount: hiddenCount,
      );
      final spacing = widget.chipSpacing ?? theme.chipSpacing;
      final runSpacing = widget.chipRunSpacing ?? theme.chipSpacing;
      if (widget.selectedItemsBuilder != null) {
        return _buildFocusableChipArea(
          Padding(
            padding: widget.chipContainerPadding,
            child: widget.selectedItemsBuilder!(context, selectedValues, state),
          ),
          spacing,
        );
      }
      final chips = <Widget>[
        for (var index = 0; index < selectedValues.length; index++)
          _buildSelectedChip(selectedValues[index], index, theme),
        if (hiddenCount > 0)
          AutocompleteChip(
            label: '+$hiddenCount',
            disabled: true,
            size: widget.size,
            backgroundColor: widget.chipBackgroundColor ?? theme.chipColor,
            textStyle: widget.chipTextStyle,
            shape: widget.chipShape,
            side: widget.chipSide,
            labelPadding: widget.chipLabelPadding,
            elevation: widget.chipElevation,
            labelMaxWidth: widget.chipLabelMaxWidth,
          ),
      ];
      final child = switch (widget.chipLayout) {
        AutocompleteChipLayout.wrap => Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: chips,
        ),
        AutocompleteChipLayout.horizontalScroll => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            children: [
              for (var index = 0; index < chips.length; index++) chips[index],
            ],
          ),
        ),
      };
      return _buildFocusableChipArea(
        Padding(padding: widget.chipContainerPadding, child: child),
        spacing,
      );
    }

    final selected = _controller.value;
    if (selected == null || widget.selectedItemBuilder == null) {
      return null;
    }
    final disabled = _controller.isSelectedItemDisabled(selected);
    return Padding(
      padding: EdgeInsets.only(right: theme.chipSpacing),
      child: widget.selectedItemBuilder!(
        context,
        selected,
        AutocompleteSelectedItemState(
          index: 0,
          disabled: disabled,
          focused: _hasFocus,
          onRemove: disabled || widget.readOnly
              ? null
              : () {
                  _controller.clear();
                  widget.onChanged?.call(null);
                },
        ),
      ),
    );
  }

  Widget _buildFocusableChipArea(Widget child, double spacing) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _focusInputFromChipArea,
        child: child,
      ),
    );
  }

  void _focusInputFromChipArea() {
    if (widget.disabled || widget.readOnly) {
      return;
    }
    _focusNode.requestFocus();
    if (widget.openOnFocus) {
      _openPopup();
    }
  }

  Widget _buildSelectedChip(
    T value,
    int visibleIndex,
    AutocompleteThemeData theme,
  ) {
    final actualIndex = _controller.values.indexWhere(
      (selected) => _controller.isOptionEqualToValue(selected, value),
    );
    final disabled =
        widget.readOnly || _controller.isSelectedItemDisabled(value);
    final state = AutocompleteSelectedItemState(
      index: actualIndex,
      disabled: disabled,
      focused: _hasFocus,
      onRemove: disabled
          ? null
          : () {
              if (_controller.removeSelectedAt(actualIndex)) {
                widget.onValuesChanged?.call(_controller.values);
              }
            },
    );
    if (widget.chipBuilder != null) {
      return widget.chipBuilder!(context, value, state);
    }
    if (widget.selectedItemBuilder != null) {
      return widget.selectedItemBuilder!(context, value, state);
    }
    return AutocompleteChip(
      label: _controller.optionLabel(value),
      disabled: disabled,
      size: widget.size,
      backgroundColor: widget.chipBackgroundColor ?? theme.chipColor,
      textStyle: widget.chipTextStyle,
      deleteIcon: widget.chipDeleteIcon,
      shape: widget.chipShape,
      side: widget.chipSide,
      labelPadding: widget.chipLabelPadding,
      elevation: widget.chipElevation,
      labelMaxWidth: widget.chipLabelMaxWidth,
      onDeleted: state.onRemove,
    );
  }

  List<T> _visibleSelectedValues() {
    final values = _controller.values;
    final limit = widget.limitTags;
    if (_hasFocus || limit == null || values.length <= limit) {
      return values;
    }
    return values.take(limit).toList(growable: false);
  }

  int _hiddenSelectedCount() {
    final limit = widget.limitTags;
    if (_hasFocus || limit == null || _controller.values.length <= limit) {
      return 0;
    }
    return _controller.values.length - limit;
  }

  Widget _buildSuffix() {
    final children = <Widget>[];
    final loading = widget.loading || _controller.loading;
    if (loading) {
      children.add(
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (_canClear) {
      children.add(
        Tooltip(
          message: 'Clear',
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: widget.clearIcon ?? const Icon(Icons.clear),
            onPressed: _clear,
          ),
        ),
      );
    }
    children.add(
      Tooltip(
        message: _controller.isOpen ? 'Close options' : 'Open options',
        child: IconButton(
          visualDensity: VisualDensity.compact,
          icon: widget.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
          onPressed: widget.disabled || widget.readOnly
              ? null
              : () {
                  if (_controller.isOpen) {
                    _closePopup(AutocompleteCloseReason.toggleInput);
                  } else {
                    _openPopup();
                  }
                },
        ),
      ),
    );
    if (widget.suffixIcon != null) {
      children.add(widget.suffixIcon!);
    } else if (widget.decoration.suffixIcon != null) {
      children.add(widget.decoration.suffixIcon!);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  bool get _canClear {
    if (widget.disableClearable || widget.disabled || widget.readOnly) {
      return false;
    }
    if (widget.multiple) {
      return _controller.values.any(
        (value) => !_controller.isSelectedItemDisabled(value),
      );
    }
    final selected = _controller.value;
    if (selected != null && _controller.isSelectedItemDisabled(selected)) {
      return _controller.inputValue.isNotEmpty;
    }
    return selected != null || _controller.inputValue.isNotEmpty;
  }

  void _handleControllerChanged() {
    _syncTextController();
    _syncOverlay();
    if (mounted) {
      setState(() {});
    }
  }

  void _syncTextController() {
    final selected = _controller.value;
    final hideSingleText =
        !widget.multiple &&
        selected != null &&
        widget.selectedItemBuilder != null &&
        !_hasFocus;
    final text = hideSingleText ? '' : _controller.inputValue;
    if (_textController.text == text) {
      return;
    }
    _updatingText = true;
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _updatingText = false;
  }

  void _handleInputChanged(String value) {
    if (_updatingText || widget.readOnly || widget.disabled) {
      return;
    }
    _controller.setInputValue(value);
    widget.onInputChanged?.call(value);
    if (widget.asyncOptionsBuilder != null) {
      unawaited(_controller.search(value));
    }
    _openPopup();
  }

  void _handleInputTap() {
    if (widget.disabled || widget.readOnly) {
      return;
    }
    if (widget.openOnFocus) {
      _openPopup();
    }
  }

  void _handleFocusChanged() {
    final focused = _focusNode.hasFocus;
    if (_hasFocus == focused) {
      return;
    }
    setState(() {
      _hasFocus = focused;
    });
    if (focused) {
      if (widget.selectOnFocus) {
        _textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _textController.text.length,
        );
      }
      if (widget.openOnFocus) {
        _openPopup();
      }
    } else {
      if (widget.autoSelect) {
        _selectHighlightedOrFreeSolo(closeAfterSelect: false);
      }
      if (widget.clearOnBlur) {
        _controller.setInputValue(
          widget.multiple || _controller.value == null
              ? ''
              : _controller.optionLabel(_controller.value as T),
          reason: AutocompleteInputChangedReason.blur,
        );
      }
      _closePopup(AutocompleteCloseReason.blur);
    }
  }

  void _openPopup() {
    if (widget.disabled || widget.readOnly) {
      return;
    }
    final wasOpen = _controller.isOpen;
    unawaited(_controller.open(autoHighlight: widget.autoHighlight));
    if (!wasOpen) {
      widget.onOpen?.call();
    }
  }

  void _closePopup(AutocompleteCloseReason reason) {
    final wasOpen = _controller.isOpen;
    _controller.close(reason: reason);
    if (wasOpen) {
      widget.onClose?.call();
    }
  }

  bool _selectHighlightedOrFreeSolo({bool closeAfterSelect = true}) {
    final beforeValues = _controller.values;
    final beforeValue = _controller.value;
    final didSelect = _controller.commitHighlightedOrFreeSolo();
    if (!didSelect) {
      return false;
    }
    if (widget.multiple) {
      if (beforeValues.length != _controller.values.length) {
        widget.onValuesChanged?.call(_controller.values);
      }
    } else if (beforeValue != _controller.value) {
      widget.onChanged?.call(_controller.value);
    }
    if (closeAfterSelect && _shouldCloseAfterSelect) {
      _closePopup(AutocompleteCloseReason.selectOption);
    }
    _handlePostSelectionFocus();
    return true;
  }

  void _selectOption(T option) {
    final didSelect = _controller.selectOption(option);
    if (!didSelect) {
      return;
    }
    if (widget.multiple) {
      widget.onValuesChanged?.call(_controller.values);
    } else {
      widget.onChanged?.call(_controller.value);
    }
    if (_shouldCloseAfterSelect) {
      _closePopup(AutocompleteCloseReason.selectOption);
    }
    _handlePostSelectionFocus();
  }

  bool get _shouldCloseAfterSelect {
    if (widget.disableCloseOnSelect) {
      return false;
    }
    if (widget.multiple && !widget.blurOnSelect) {
      return false;
    }
    return true;
  }

  void _handlePostSelectionFocus() {
    if (widget.blurOnSelect) {
      _focusNode.unfocus();
      return;
    }
    _focusNode.requestFocus();
    if (widget.multiple) {
      _openPopup();
    }
  }

  void _clear() {
    if (widget.disableClearable) {
      return;
    }
    if (widget.multiple) {
      final fixedValues = _controller.values
          .where(_controller.isSelectedItemDisabled)
          .toList(growable: false);
      _controller.setValues(fixedValues);
      _controller.setInputValue(
        '',
        reason: AutocompleteInputChangedReason.clear,
      );
    } else if (_controller.value != null &&
        _controller.isSelectedItemDisabled(_controller.value as T)) {
      _controller.setInputValue(
        '',
        reason: AutocompleteInputChangedReason.clear,
      );
    } else {
      _controller.clear();
    }
    widget.onInputChanged?.call('');
    if (widget.multiple) {
      widget.onValuesChanged?.call(_controller.values);
    } else {
      widget.onChanged?.call(null);
    }
  }

  void _syncOverlay() {
    if (!mounted) {
      return;
    }
    if (_controller.isOpen && !widget.disabled) {
      _overlayEntry ??= OverlayEntry(builder: _buildOverlay);
      if (!_overlayInserted) {
        Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
        _overlayInserted = true;
      } else {
        _overlayEntry!.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
  }

  Widget _buildOverlay(BuildContext context) {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldSize = renderBox?.size ?? Size.zero;
    final popupWidth = widget.popupWidth ?? fieldSize.width;
    final theme = AutocompleteThemeData.resolve(
      Theme.of(context),
      widget.theme,
    );
    return Positioned.fill(
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, fieldSize.height + 4),
        child: TextFieldTapRegion(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: popupWidth,
              child: AutocompletePopup<T>(
                options: _controller.filteredOptions,
                getOptionLabel: _controller.optionLabel,
                getOptionKey: _controller.optionKey,
                isOptionSelected: _controller.isOptionSelected,
                isOptionDisabled: _controller.isOptionDisabled,
                highlightedIndex: _controller.highlightedIndex,
                inputValue: _controller.inputValue,
                onOptionTap: _selectOption,
                onOptionHover: _controller.setHighlightedIndex,
                groupBy: widget.groupBy,
                optionBuilder: widget.optionBuilder,
                groupBuilder: widget.groupBuilder,
                stickyGroupHeaders: widget.stickyGroupHeaders,
                groupHeaderHeight: widget.groupHeaderHeight,
                theme: theme,
                size: widget.size,
                maxHeight: widget.popupMaxHeight ?? 280,
                virtualized: widget.virtualized,
                loading: widget.loading || _controller.loading,
                loadingText: widget.loadingText ?? 'Loading...',
                noOptionsText: widget.noOptionsText ?? 'No options',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayInserted) {
      _overlayEntry?.remove();
    }
    _overlayInserted = false;
    _overlayEntry = null;
  }
}
