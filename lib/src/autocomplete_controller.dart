import 'package:flutter/foundation.dart';

import 'autocomplete_filter.dart';
import 'autocomplete_types.dart';

/// State controller for [AutocompleteField].
///
/// The controller keeps the selected value state separate from the input text
/// state, mirroring MUI's `value` and `inputValue` model. It can be used
/// directly for headless tests or advanced custom widgets.
class AutocompleteController<T> extends ChangeNotifier {
  /// Creates an autocomplete controller.
  AutocompleteController({
    List<T> options = const [],
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteOptionDisabled<T>? getSelectedItemDisabled,
    AutocompleteFilterCallback<T>? filterOptions,
    T? value,
    List<T>? values,
    T? defaultValue,
    List<T>? defaultValues,
    String inputValue = '',
    bool multiple = false,
    bool freeSolo = false,
    bool filterSelectedOptions = false,
    AutocompleteAsyncOptionsBuilder<T>? asyncOptionsBuilder,
    AutocompleteLoadOptionsOnOpen<T>? loadOptionsOnOpen,
  }) : _options = List<T>.of(options),
       _getOptionLabel = getOptionLabel ?? defaultAutocompleteOptionLabel<T>,
       _getOptionKey = getOptionKey,
       _isOptionEqualToValue = isOptionEqualToValue,
       _getOptionDisabled = getOptionDisabled,
       _getSelectedItemDisabled = getSelectedItemDisabled,
       _filterOptions = filterOptions ?? createAutocompleteFilter<T>(),
       _multiple = multiple,
       _freeSolo = freeSolo,
       _filterSelectedOptions = filterSelectedOptions,
       _asyncOptionsBuilder = asyncOptionsBuilder,
       _loadOptionsOnOpen = loadOptionsOnOpen,
       _value = value ?? defaultValue,
       _values = List<T>.of(values ?? defaultValues ?? <T>[]),
       _inputValue = inputValue {
    if (_inputValue.isEmpty && !_multiple && _value != null) {
      _inputValue = _getOptionLabel(_value as T);
    }
    _recomputeFilteredOptions();
  }

  List<T> _options;
  List<T> _filteredOptions = <T>[];
  AutocompleteOptionLabel<T> _getOptionLabel;
  AutocompleteOptionKey<T>? _getOptionKey;
  AutocompleteOptionEquality<T>? _isOptionEqualToValue;
  AutocompleteOptionDisabled<T>? _getOptionDisabled;
  AutocompleteOptionDisabled<T>? _getSelectedItemDisabled;
  AutocompleteFilterCallback<T> _filterOptions;
  AutocompleteAsyncOptionsBuilder<T>? _asyncOptionsBuilder;
  AutocompleteLoadOptionsOnOpen<T>? _loadOptionsOnOpen;

  T? _value;
  List<T> _values;
  String _inputValue;
  bool _multiple;
  bool _freeSolo;
  bool _filterSelectedOptions;
  bool _open = false;
  bool _loading = false;
  int _highlightedIndex = -1;
  int _requestSerial = 0;
  bool _loadedOnOpen = false;

  /// Last value change reason produced by a controller method.
  AutocompleteValueChangedReason? lastValueChangedReason;

  /// Last input change reason produced by a controller method.
  AutocompleteInputChangedReason? lastInputChangedReason;

  /// Last close reason produced by a controller method.
  AutocompleteCloseReason? lastCloseReason;

  /// All currently available options.
  List<T> get options => List<T>.unmodifiable(_options);

  /// Options after filtering and selected-option exclusion.
  List<T> get filteredOptions => List<T>.unmodifiable(_filteredOptions);

  /// Current single selected value.
  T? get value => _value;

  /// Current selected values in multiple mode.
  List<T> get values => List<T>.unmodifiable(_values);

  /// Current input text.
  String get inputValue => _inputValue;

  /// Whether the popup is open.
  bool get isOpen => _open;

  /// Whether async option loading is in progress.
  bool get loading => _loading;

  /// Index of the highlighted option in [filteredOptions], or `-1`.
  int get highlightedIndex => _highlightedIndex;

  /// Highlighted option, if an enabled option is highlighted.
  T? get highlightedOption {
    if (_highlightedIndex < 0 || _highlightedIndex >= _filteredOptions.length) {
      return null;
    }
    return _filteredOptions[_highlightedIndex];
  }

  /// Whether the controller is in multiple-selection mode.
  bool get multiple => _multiple;

  /// Whether arbitrary text can be committed as a value.
  bool get freeSolo => _freeSolo;

  /// Updates non-value configuration while preserving state.
  void updateConfiguration({
    List<T>? options,
    AutocompleteOptionLabel<T>? getOptionLabel,
    AutocompleteOptionKey<T>? getOptionKey,
    AutocompleteOptionEquality<T>? isOptionEqualToValue,
    AutocompleteOptionDisabled<T>? getOptionDisabled,
    AutocompleteOptionDisabled<T>? getSelectedItemDisabled,
    AutocompleteFilterCallback<T>? filterOptions,
    bool? multiple,
    bool? freeSolo,
    bool? filterSelectedOptions,
    AutocompleteAsyncOptionsBuilder<T>? asyncOptionsBuilder,
    AutocompleteLoadOptionsOnOpen<T>? loadOptionsOnOpen,
  }) {
    if (options != null) {
      _options = List<T>.of(options);
    }
    if (getOptionLabel != null) {
      _getOptionLabel = getOptionLabel;
    }
    _getOptionKey = getOptionKey;
    _isOptionEqualToValue = isOptionEqualToValue;
    _getOptionDisabled = getOptionDisabled;
    _getSelectedItemDisabled = getSelectedItemDisabled;
    if (filterOptions != null) {
      _filterOptions = filterOptions;
    }
    if (multiple != null) {
      _multiple = multiple;
    }
    if (freeSolo != null) {
      _freeSolo = freeSolo;
    }
    if (filterSelectedOptions != null) {
      _filterSelectedOptions = filterSelectedOptions;
    }
    _asyncOptionsBuilder = asyncOptionsBuilder;
    _loadOptionsOnOpen = loadOptionsOnOpen;
    _recomputeFilteredOptions();
    notifyListeners();
  }

  /// Replaces the available options.
  void setOptions(List<T> options) {
    _options = List<T>.of(options);
    _recomputeFilteredOptions();
    notifyListeners();
  }

  /// Sets whether async loading is in progress.
  void setLoading(bool loading) {
    if (_loading == loading) {
      return;
    }
    _loading = loading;
    notifyListeners();
  }

  /// Replaces the single selected value.
  void setValue(T? value, {bool updateInput = true}) {
    _value = value;
    if (updateInput) {
      _inputValue = value == null ? '' : _getOptionLabel(value);
      lastInputChangedReason = AutocompleteInputChangedReason.reset;
    }
    _recomputeFilteredOptions();
    notifyListeners();
  }

  /// Replaces all selected values in multiple mode.
  void setValues(List<T> values) {
    _values = List<T>.of(values);
    _recomputeFilteredOptions();
    notifyListeners();
  }

  /// Replaces the current input text.
  void setInputValue(
    String value, {
    AutocompleteInputChangedReason reason =
        AutocompleteInputChangedReason.input,
  }) {
    if (_inputValue == value) {
      return;
    }
    _inputValue = value;
    lastInputChangedReason = reason;
    _recomputeFilteredOptions();
    _coerceHighlightAfterFilter();
    notifyListeners();
  }

  /// Opens the popup.
  Future<void> open({bool autoHighlight = false}) async {
    if (!_open) {
      _open = true;
      if (autoHighlight) {
        highlightFirst(notify: false);
      }
      notifyListeners();
    } else if (autoHighlight && _highlightedIndex < 0) {
      highlightFirst();
    }

    if (_loadOptionsOnOpen != null && !_loadedOnOpen) {
      _loadedOnOpen = true;
      await loadOptionsForOpen();
    }
  }

  /// Closes the popup.
  void close({
    AutocompleteCloseReason reason = AutocompleteCloseReason.toggleInput,
  }) {
    if (!_open) {
      return;
    }
    _open = false;
    _highlightedIndex = -1;
    lastCloseReason = reason;
    notifyListeners();
  }

  /// Clears selected values and input text.
  void clear() {
    _value = null;
    _values = <T>[];
    _inputValue = '';
    _highlightedIndex = -1;
    lastValueChangedReason = AutocompleteValueChangedReason.clear;
    lastInputChangedReason = AutocompleteInputChangedReason.clear;
    _recomputeFilteredOptions();
    notifyListeners();
  }

  /// Selects [option] if it is not disabled.
  bool selectOption(
    T option, {
    AutocompleteValueChangedReason reason =
        AutocompleteValueChangedReason.selectOption,
  }) {
    if (isOptionDisabled(option)) {
      return false;
    }
    if (_multiple) {
      if (!_values.any((value) => isOptionEqualToValue(option, value))) {
        _values = <T>[..._values, option];
      }
      _inputValue = '';
    } else {
      _value = option;
      _inputValue = _getOptionLabel(option);
    }
    lastValueChangedReason = reason;
    lastInputChangedReason = AutocompleteInputChangedReason.selectOption;
    _recomputeFilteredOptions();
    _coerceHighlightAfterFilter();
    notifyListeners();
    return true;
  }

  /// Commits typed free-solo text as a value when possible.
  ///
  /// MUI notes that free-solo values created from text are strings even when
  /// options are objects. In Dart this can only be committed when [T] accepts a
  /// string, so non-string generic types return `false`.
  bool selectFreeSoloText() {
    if (!_freeSolo || _inputValue.isEmpty) {
      return false;
    }
    final text = _inputValue;
    if (T != String && text is! T) {
      return false;
    }
    return selectOption(
      text as T,
      reason: AutocompleteValueChangedReason.createOption,
    );
  }

  /// Selects the highlighted option, or free-solo text when enabled.
  bool commitHighlightedOrFreeSolo() {
    final highlighted = highlightedOption;
    if (highlighted != null) {
      return selectOption(highlighted);
    }
    return selectFreeSoloText();
  }

  /// Removes [value] from the selected values.
  bool removeSelectedValue(T value) {
    final index = _values.indexWhere(
      (selected) => isOptionEqualToValue(selected, value),
    );
    if (index == -1) {
      return false;
    }
    return removeSelectedAt(index);
  }

  /// Removes a selected value by [index].
  bool removeSelectedAt(int index) {
    if (index < 0 || index >= _values.length) {
      return false;
    }
    final value = _values[index];
    if (isSelectedItemDisabled(value)) {
      return false;
    }
    _values = <T>[..._values]..removeAt(index);
    lastValueChangedReason = AutocompleteValueChangedReason.removeOption;
    _recomputeFilteredOptions();
    notifyListeners();
    return true;
  }

  /// Removes the last selected value that is not disabled.
  bool removeLastSelectedValue() {
    for (var index = _values.length - 1; index >= 0; index--) {
      if (!isSelectedItemDisabled(_values[index])) {
        return removeSelectedAt(index);
      }
    }
    return false;
  }

  /// Moves highlight by [delta], skipping disabled options.
  void moveHighlight(int delta, {bool wrap = true}) {
    if (_filteredOptions.isEmpty) {
      setHighlightedIndex(-1);
      return;
    }

    final length = _filteredOptions.length;
    var index = _highlightedIndex;
    if (index == -1) {
      index = delta >= 0 ? -1 : length;
    }

    for (var attempts = 0; attempts < length; attempts++) {
      index += delta;
      if (wrap) {
        index = (index + length) % length;
      } else if (index < 0 || index >= length) {
        return;
      }

      if (!isOptionDisabled(_filteredOptions[index])) {
        setHighlightedIndex(index);
        return;
      }
    }
  }

  /// Highlights the first enabled option.
  void highlightFirst({bool notify = true}) {
    for (var index = 0; index < _filteredOptions.length; index++) {
      if (!isOptionDisabled(_filteredOptions[index])) {
        _highlightedIndex = index;
        if (notify) {
          notifyListeners();
        }
        return;
      }
    }
    _highlightedIndex = -1;
    if (notify) {
      notifyListeners();
    }
  }

  /// Highlights the last enabled option.
  void highlightLast() {
    for (var index = _filteredOptions.length - 1; index >= 0; index--) {
      if (!isOptionDisabled(_filteredOptions[index])) {
        setHighlightedIndex(index);
        return;
      }
    }
    setHighlightedIndex(-1);
  }

  /// Sets the highlighted option index.
  void setHighlightedIndex(int index) {
    final next = index < 0 || index >= _filteredOptions.length ? -1 : index;
    if (_highlightedIndex == next) {
      return;
    }
    _highlightedIndex = next;
    notifyListeners();
  }

  /// Returns the display label for [option].
  String optionLabel(T option) => _getOptionLabel(option);

  /// Returns the stable key for [option].
  Object optionKey(T option) =>
      _getOptionKey?.call(option) ?? _getOptionLabel(option);

  /// Returns whether [option] is disabled.
  bool isOptionDisabled(T option) => _getOptionDisabled?.call(option) ?? false;

  /// Returns whether selected [value] is fixed and cannot be removed.
  bool isSelectedItemDisabled(T value) {
    return _getSelectedItemDisabled?.call(value) ?? false;
  }

  /// Returns whether [option] and [value] are equal.
  bool isOptionEqualToValue(T option, T value) {
    return _isOptionEqualToValue?.call(option, value) ?? option == value;
  }

  /// Returns whether [option] is currently selected.
  bool isOptionSelected(T option) {
    if (_multiple) {
      return _values.any((value) => isOptionEqualToValue(option, value));
    }
    final selected = _value;
    return selected != null && isOptionEqualToValue(option, selected);
  }

  /// Loads options using the load-on-open callback.
  Future<void> loadOptionsForOpen() async {
    final loader = _loadOptionsOnOpen;
    if (loader == null) {
      return;
    }
    final requestId = ++_requestSerial;
    setLoading(true);
    try {
      final nextOptions = await loader();
      if (requestId == _requestSerial) {
        _options = List<T>.of(nextOptions);
        _recomputeFilteredOptions();
      }
    } finally {
      if (requestId == _requestSerial) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  /// Loads options for [query] using the async search callback.
  Future<void> search(String query) async {
    final builder = _asyncOptionsBuilder;
    if (builder == null) {
      return;
    }
    final requestId = ++_requestSerial;
    setLoading(true);
    try {
      final nextOptions = await builder(query);
      if (requestId == _requestSerial) {
        _options = List<T>.of(nextOptions);
        _recomputeFilteredOptions();
        _coerceHighlightAfterFilter();
      }
    } finally {
      if (requestId == _requestSerial) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  void _recomputeFilteredOptions() {
    var nextOptions = List<T>.of(_options);
    if (_filterSelectedOptions) {
      nextOptions = nextOptions
          .where((option) => !isOptionSelected(option))
          .toList(growable: false);
    }
    _filteredOptions = _filterOptions(
      nextOptions,
      AutocompleteFilterState<T>(
        inputValue: _inputValue,
        getOptionLabel: _getOptionLabel,
      ),
    );
  }

  void _coerceHighlightAfterFilter() {
    if (_highlightedIndex >= _filteredOptions.length) {
      _highlightedIndex = _filteredOptions.isEmpty
          ? -1
          : _filteredOptions.length - 1;
    }
    if (_highlightedIndex >= 0 &&
        isOptionDisabled(_filteredOptions[_highlightedIndex])) {
      moveHighlight(1);
    }
  }
}
