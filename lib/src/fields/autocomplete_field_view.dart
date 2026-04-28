import 'package:flutter/material.dart';

import '../async/async_options_controller.dart';
import '../chips/autocomplete_chip_wrap.dart';
import '../configs/autocomplete_creatable_config.dart';
import '../filtering/default_filter.dart';
import '../popup/autocomplete_popup.dart';
import 'autocomplete_field_configuration.dart';
import 'single_autocomplete_input.dart';

class AutocompleteFieldView<T> extends StatefulWidget {
  const AutocompleteFieldView({required this.configuration, super.key});

  final AutocompleteFieldConfiguration<T> configuration;

  @override
  State<AutocompleteFieldView<T>> createState() =>
      _AutocompleteFieldViewState<T>();
}

class _AutocompleteFieldViewState<T> extends State<AutocompleteFieldView<T>> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final GlobalKey _fieldKey = GlobalKey();
  final Object _tapRegionGroupId = Object();

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _ownsController;
  late bool _ownsFocusNode;

  AsyncOptionsController<T>? _asyncController;
  List<T> _selectedValues = <T>[];
  T? _selectedValue;
  List<T> _asyncOptions = const [];
  List<T> _createdOptions = const [];
  bool _isLoading = false;
  bool _isOpen = false;
  double? _fieldWidth;

  @override
  void initState() {
    super.initState();
    _configureTextEditingController();
    _configureFocusNode();
    _syncSelectionFromConfiguration(resetText: true);
    _configureAsyncController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFieldWidth());
  }

  @override
  void didUpdateWidget(covariant AutocompleteFieldView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration.controller != widget.configuration.controller) {
      _replaceController(oldWidget.configuration.controller);
    }
    if (oldWidget.configuration.focusNode != widget.configuration.focusNode) {
      _replaceFocusNode(oldWidget.configuration.focusNode);
    }
    if (oldWidget.configuration.asyncConfig !=
        widget.configuration.asyncConfig) {
      _asyncController?.dispose();
      _configureAsyncController();
    }
    if (_didExternalSelectionChange(oldWidget.configuration)) {
      _syncSelectionFromConfiguration();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFieldWidth());
  }

  @override
  void dispose() {
    _asyncController?.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFieldWidth());

    final field = widget.configuration.isMultiple
        ? AutocompleteChipWrap<T>(
            values: _selectedValues,
            getOptionLabel: widget.configuration.getOptionLabel,
            isFixed: _isFixedChip,
            onDelete: _removeValue,
            controller: _controller,
            focusNode: _focusNode,
            decoration: widget.configuration.decoration,
            enabled: widget.configuration.enabled,
            readOnly: widget.configuration.readOnly,
            autofocus: widget.configuration.autofocus,
            chipConfig: widget.configuration.chipConfig!,
            renderingConfig: widget.configuration.renderingConfig,
            suffixIcon: _buildClearButton(),
            onChanged: _handleInputChanged,
          )
        : SingleAutocompleteInput<T>(
            controller: _controller,
            focusNode: _focusNode,
            decoration: widget.configuration.decoration,
            enabled: widget.configuration.enabled,
            readOnly: widget.configuration.readOnly,
            autofocus: widget.configuration.autofocus,
            onChanged: _handleInputChanged,
            suffixIcon: _buildClearButton(),
            selectedValue: _selectedValue,
            selectedLabel: _selectedValue == null
                ? null
                : widget.configuration.getOptionLabel(_selectedValue as T),
            selectedItemBuilder:
                widget.configuration.renderingConfig?.selectedItemBuilder,
          );

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) {
        if (!_shouldRenderPopup) {
          return const SizedBox.shrink();
        }
        final targetRect = _resolveTargetRect(context);
        if (targetRect == null) {
          return const SizedBox.shrink();
        }

        final popupWidth =
            widget.configuration.popupConfig.width ?? _fieldWidth;
        final popupOffset = widget.configuration.popupConfig.offset;

        return Stack(
          children: [
            Positioned(
              left: targetRect.left + popupOffset.dx,
              top: targetRect.bottom + popupOffset.dy,
              width: popupWidth,
              child: TapRegion(
                groupId: _tapRegionGroupId,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: popupWidth ?? 320),
                  child: AutocompletePopup<T>(
                    options: _visibleOptions,
                    query: _controller.text,
                    getOptionLabel: widget.configuration.getOptionLabel,
                    isSelected: _isOptionSelected,
                    onOptionTap: _selectOption,
                    popupConfig: widget.configuration.popupConfig,
                    selectionConfig: widget.configuration.selectionConfig,
                    groupingConfig: widget.configuration.groupingConfig,
                    renderingConfig: widget.configuration.renderingConfig,
                    isLoading: _isLoading,
                    highlightedOption: _highlightedOption,
                    createInput: _createOptionInput,
                    createLabel: _createOptionInput == null
                        ? null
                        : _config.creatableConfig?.createLabel?.call(
                            _createOptionInput!,
                          ),
                    onCreateTap: _handleCreateOption,
                    createOptionBuilder: widget
                        .configuration.creatableConfig?.createOptionBuilder,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: TapRegion(
        groupId: _tapRegionGroupId,
        onTapOutside: (_) => _handleTapOutside(),
        child: Container(key: _fieldKey, child: field),
      ),
    );
  }

  AutocompleteFieldConfiguration<T> get _config => widget.configuration;

  List<T> get _allOptions {
    if (_config.isAsync) {
      return _asyncOptions;
    }
    return <T>[...?_config.options, ..._createdOptions];
  }

  List<T> get _visibleOptions {
    final query = _controller.text;
    if (!_shouldShowOptionsForQuery(query)) {
      return const [];
    }

    var options = applyAutocompleteFilter<T>(
      options: _allOptions,
      query: query,
      getOptionLabel: _config.getOptionLabel,
      filterConfig: _config.filterConfig,
    );

    if (!_config.selectionConfig.keepSelectedOptionsVisible) {
      options = options.where((option) => !_isOptionSelected(option)).toList();
    }
    return options;
  }

  T? get _highlightedOption {
    if (!_config.behaviorConfig.autoHighlight || _visibleOptions.isEmpty) {
      return null;
    }
    return _visibleOptions.first;
  }

  String? get _createOptionInput {
    if (!_config.isCreatable) {
      return null;
    }

    final creatable = _config.creatableConfig!;
    final rawInput =
        creatable.trimInput ? _controller.text.trim() : _controller.text;
    if (rawInput.length < creatable.minInputLength) {
      return null;
    }
    if (_matchesExistingOption(rawInput, _allOptions)) {
      return null;
    }
    if (_config.isMultiple &&
        _matchesExistingOption(rawInput, _selectedValues)) {
      return null;
    }
    if (creatable.shouldShowCreateOption != null &&
        !creatable.shouldShowCreateOption!(rawInput, _allOptions)) {
      return null;
    }
    return rawInput;
  }

  bool get _shouldRenderPopup {
    if (!_isOpen) {
      return false;
    }
    if (_isLoading) {
      return true;
    }
    return _visibleOptions.isNotEmpty || _createOptionInput != null;
  }

  void _configureTextEditingController() {
    _ownsController = widget.configuration.controller == null;
    _controller = widget.configuration.controller ?? TextEditingController();
  }

  void _configureFocusNode() {
    _ownsFocusNode = widget.configuration.focusNode == null;
    _focusNode = widget.configuration.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _configureAsyncController() {
    if (!_config.isAsync) {
      return;
    }
    _asyncController = AsyncOptionsController<T>(
      config: _config.asyncConfig!,
      onUpdate: (update) {
        if (!mounted || update.query != _controller.text) {
          return;
        }
        setState(() {
          _asyncOptions = update.options;
          _isLoading = update.isLoading;
        });
        _syncOverlayVisibility();
      },
    );
  }

  void _replaceController(TextEditingController? oldController) {
    if (_ownsController) {
      _controller.dispose();
    }
    _configureTextEditingController();
    _syncSelectionFromConfiguration(resetText: true);
  }

  void _replaceFocusNode(FocusNode? oldFocusNode) {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _configureFocusNode();
  }

  void _syncSelectionFromConfiguration({bool resetText = false}) {
    if (_config.isMultiple) {
      _selectedValues = List<T>.from(_config.values ?? const []);
      if (resetText && _config.behaviorConfig.clearInputOnSelect) {
        _controller.clear();
      }
      return;
    }

    _selectedValue = _config.value;
    if (_selectedValue == null) {
      if (resetText) {
        _controller.clear();
      }
      return;
    }
    if (resetText || _controller.text.isEmpty || !_focusNode.hasFocus) {
      _controller.text = _config.getOptionLabel(_selectedValue as T);
    }
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }

    if (_focusNode.hasFocus) {
      if (_config.isAsync &&
          _config.asyncConfig!.loadOnFocus &&
          _controller.text.isEmpty) {
        _requestAsyncOptions(immediate: true);
      }
      if (_config.behaviorConfig.openOnFocus) {
        _syncOverlayVisibility(forceOpen: true);
      }
    } else {
      if (_config.behaviorConfig.clearOnBlur) {
        _clearQueryOnBlur();
      }
      _closePopup();
    }
    setState(() {});
  }

  void _handleInputChanged(String value) {
    if (_config.isAsync) {
      _requestAsyncOptions();
    }
    _syncOverlayVisibility(forceOpen: _focusNode.hasFocus);
    setState(() {});
  }

  void _clearField() {
    if (_config.isMultiple) {
      setState(() {
        _selectedValues = <T>[];
        _controller.clear();
      });
      _config.onValuesChanged?.call(const []);
    } else {
      setState(() {
        _selectedValue = null;
        _controller.clear();
      });
      _config.onChanged?.call(null);
    }

    if (_config.isAsync && _focusNode.hasFocus) {
      _requestAsyncOptions(immediate: true);
    }
    _syncOverlayVisibility(forceOpen: _focusNode.hasFocus);
  }

  void _requestAsyncOptions({bool immediate = false}) {
    final query = _controller.text;
    final asyncConfig = _config.asyncConfig!;
    final meetsMinimum = query.length >= asyncConfig.minQueryLength;
    final allowEmptyFocusLoad = query.isEmpty && asyncConfig.loadOnFocus;
    if (!meetsMinimum && !allowEmptyFocusLoad) {
      _asyncController?.cancel();
      setState(() {
        _asyncOptions = const [];
        _isLoading = false;
      });
      return;
    }

    _asyncController?.request(
      query,
      currentOptions: _asyncOptions,
      immediate: immediate,
    );
  }

  void _selectOption(T option) {
    if (_config.isMultiple) {
      if (_isOptionSelected(option)) {
        return;
      }
      final nextValues = [..._selectedValues, option];
      setState(() {
        _selectedValues = nextValues;
        if (_config.behaviorConfig.clearInputOnSelect) {
          _controller.clear();
        }
      });
      _config.onValuesChanged?.call(List<T>.unmodifiable(nextValues));
    } else {
      setState(() {
        _selectedValue = option;
        if (_config.behaviorConfig.clearInputOnSelect) {
          _controller.clear();
        } else {
          _controller.text = _config.getOptionLabel(option);
        }
      });
      _config.onChanged?.call(option);
    }

    _afterSelection();
  }

  void _handleCreateOption() {
    final input = _createOptionInput;
    if (input == null) {
      return;
    }

    final creatable = _config.creatableConfig as AutocompleteCreatableConfig<T>;
    final created = creatable.createOption(input);
    if (!_matchesOption(created, _allOptions)) {
      setState(() {
        _createdOptions = [..._createdOptions, created];
      });
    }

    if (_config.isMultiple && _isOptionSelected(created)) {
      return;
    }

    _selectOption(created);
    if (creatable.clearInputOnCreate) {
      _controller.clear();
    } else if (!_config.isMultiple) {
      _controller.text = _config.getOptionLabel(created);
    }
    setState(() {});
  }

  void _afterSelection() {
    final shouldClose = _config.behaviorConfig.closeOnSelect &&
        !_config.behaviorConfig.disableCloseOnSelect;
    if (shouldClose) {
      _closePopup();
    } else {
      _openPopup();
    }

    if (_config.behaviorConfig.blurOnSelect) {
      _focusNode.unfocus();
    } else if (_config.enabled && !_config.readOnly) {
      _focusNode.requestFocus();
    }
    if (!shouldClose) {
      _syncOverlayVisibility();
    }
  }

  void _removeValue(T value) {
    if (_isFixedChip(value)) {
      return;
    }
    final nextValues = _selectedValues
        .where((item) => !_isEqual(item, value))
        .toList(growable: false);
    setState(() {
      _selectedValues = nextValues;
    });
    _config.onValuesChanged?.call(nextValues);
  }

  void _handleTapOutside() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      _closePopup();
    }
  }

  void _syncOverlayVisibility({bool forceOpen = false}) {
    final shouldOpen = (forceOpen || _focusNode.hasFocus) &&
        (_isLoading ||
            _visibleOptions.isNotEmpty ||
            _createOptionInput != null);
    if (shouldOpen) {
      _openPopup();
    } else {
      _closePopup();
    }
  }

  void _openPopup() {
    if (_isOpen) {
      return;
    }
    _overlayController.show();
    setState(() {
      _isOpen = true;
    });
  }

  void _closePopup() {
    if (!_isOpen) {
      return;
    }
    _overlayController.hide();
    setState(() {
      _isOpen = false;
    });
  }

  bool _shouldShowOptionsForQuery(String query) {
    if (_config.behaviorConfig.showOptionsOnEmptyInput) {
      return true;
    }
    return query.trim().isNotEmpty;
  }

  bool _isOptionSelected(T option) {
    if (_config.isMultiple) {
      return _selectedValues.any((selected) => _isEqual(option, selected));
    }
    return _selectedValue != null && _isEqual(option, _selectedValue as T);
  }

  bool _matchesExistingOption(String input, List<T> options) {
    return options.any((option) => _matchesInput(option, input));
  }

  bool _matchesInput(T option, String input) {
    final creatable = _config.creatableConfig;
    if (creatable?.optionMatchesInput case final matcher?) {
      return matcher(input, option, _config.getOptionLabel);
    }

    final shouldTrim = creatable?.trimInput ?? true;
    final isCaseSensitive = creatable?.caseSensitive ?? false;
    final normalizedInput = shouldTrim ? input.trim() : input;
    final optionLabel = _config.getOptionLabel(option);
    String transform(String value) {
      final trimmed = shouldTrim ? value.trim() : value;
      return isCaseSensitive ? trimmed : trimmed.toLowerCase();
    }

    return transform(optionLabel) == transform(normalizedInput);
  }

  bool _matchesOption(T option, List<T> options) {
    return options.any((item) => _isEqual(option, item));
  }

  bool _isEqual(T option, T value) {
    return _config.isOptionEqualToValue?.call(option, value) ?? option == value;
  }

  bool _isFixedChip(T value) {
    final chipConfig = _config.chipConfig;
    if (chipConfig == null) {
      return false;
    }
    return chipConfig.fixedValues.any((item) => _isEqual(item, value));
  }

  void _clearQueryOnBlur() {
    if (_config.isMultiple || _selectedValue == null) {
      _controller.clear();
      return;
    }
    _controller.text = _config.getOptionLabel(_selectedValue as T);
  }

  void _measureFieldWidth() {
    final context = _fieldKey.currentContext;
    if (context == null) {
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    final width = renderBox?.size.width;
    if (width != null && width != _fieldWidth && mounted) {
      setState(() {
        _fieldWidth = width;
      });
    }
  }

  Rect? _resolveTargetRect(BuildContext overlayContext) {
    final fieldContext = _fieldKey.currentContext;
    if (fieldContext == null) {
      return null;
    }

    final overlayRenderObject =
        Overlay.of(overlayContext).context.findRenderObject();
    final fieldRenderObject = fieldContext.findRenderObject();
    if (overlayRenderObject is! RenderBox || fieldRenderObject is! RenderBox) {
      return null;
    }

    final origin = fieldRenderObject.localToGlobal(
      Offset.zero,
      ancestor: overlayRenderObject,
    );
    return origin & fieldRenderObject.size;
  }

  bool _didExternalSelectionChange(
    AutocompleteFieldConfiguration<T> oldConfiguration,
  ) {
    if (_config.isMultiple) {
      return !_listEquals(
        oldConfiguration.values ?? const [],
        _config.values ?? const [],
      );
    }
    final previous = oldConfiguration.value;
    final current = _config.value;
    if (previous == null || current == null) {
      return previous != current;
    }
    return !_isEqual(previous, current);
  }

  bool _listEquals(List<T> a, List<T> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var index = 0; index < a.length; index += 1) {
      if (!_isEqual(a[index], b[index])) {
        return false;
      }
    }
    return true;
  }

  Widget? _buildClearButton() {
    if (!_config.clearButtonConfig.enabled ||
        !_config.enabled ||
        _config.readOnly ||
        !_hasContentToClear) {
      return null;
    }

    return IconButton(
      key: const ValueKey<String>('autocomplete-clear-button'),
      tooltip: _config.clearButtonConfig.tooltip,
      onPressed: _clearField,
      icon: _config.clearButtonConfig.icon,
    );
  }

  bool get _hasContentToClear {
    if (_controller.text.isNotEmpty) {
      return true;
    }
    if (_config.isMultiple) {
      return _selectedValues.isNotEmpty;
    }
    return _selectedValue != null;
  }
}
