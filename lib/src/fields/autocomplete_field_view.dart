import 'package:flutter/material.dart';

import '../async/async_options_controller.dart';
import '../chips/autocomplete_chip_wrap.dart';
import '../configs/autocomplete_async_pagination_config.dart';
import '../configs/autocomplete_creatable_config.dart';
import '../configs/autocomplete_popup_config.dart';
import '../filtering/default_filter.dart';
import '../popup/autocomplete_popup.dart';
import 'autocomplete_field_configuration.dart';
import 'single_autocomplete_input.dart';

/// Calculated popup geometry relative to the overlay coordinate space.
class _PopupPlacement {
  /// Creates immutable placement values for the popup surface.
  const _PopupPlacement({
    required this.left,
    required this.top,
    required this.width,
    required this.maxHeight,
  });

  /// Left coordinate of the popup surface.
  final double left;

  /// Top coordinate of the popup surface.
  final double top;

  /// Popup width.
  final double width;

  /// Maximum height available for popup content.
  final double maxHeight;
}

/// Internal stateful renderer for autocomplete field behavior.
///
/// Responsibilities:
/// - synchronize selection and query state;
/// - orchestrate async loading/debouncing;
/// - manage popup overlay visibility and placement;
/// - compose either single-input or chip-input presentation.
class AutocompleteFieldView<T> extends StatefulWidget {
  /// Creates a field view from a normalized [configuration].
  const AutocompleteFieldView({required this.configuration, super.key});

  /// Complete behavior/rendering configuration for this instance.
  final AutocompleteFieldConfiguration<T> configuration;

  @override
  State<AutocompleteFieldView<T>> createState() =>
      _AutocompleteFieldViewState<T>();
}

/// Stateful implementation for [AutocompleteFieldView].
///
/// Private state is intentionally centralized here to keep mode-specific
/// constructors in [AutocompleteField] small and declarative.
class _AutocompleteFieldViewState<T> extends State<AutocompleteFieldView<T>> {
  /// Controls whether the popup overlay is shown.
  final OverlayPortalController _overlayController = OverlayPortalController();

  /// Key for measuring and anchoring the field container.
  final GlobalKey _fieldKey = GlobalKey();

  /// Shared tap-region identifier used to detect outside taps.
  final Object _tapRegionGroupId = Object();

  /// Query text controller (owned locally unless externally provided).
  late TextEditingController _controller;

  /// Focus node (owned locally unless externally provided).
  late FocusNode _focusNode;

  /// Whether this state object owns [_controller] disposal.
  late bool _ownsController;

  /// Whether this state object owns [_focusNode] disposal.
  late bool _ownsFocusNode;

  /// Async request coordinator for async modes.
  AsyncOptionsController<T>? _asyncController;

  /// Current selected values for multiple mode.
  List<T> _selectedValues = <T>[];

  /// Current selected value for single mode.
  T? _selectedValue;

  /// Latest async options payload.
  List<T> _asyncOptions = const [];

  /// Whether an async request is currently in-flight.
  bool _isLoading = false;

  /// Whether async options have been loaded at least once for current config.
  bool _hasLoadedAsyncOptions = false;

  /// Whether an async next-page request is currently in-flight.
  bool _isLoadingMore = false;

  /// Whether a debounced async request is pending.
  bool _isDebouncing = false;

  /// Current loaded page number for async pagination.
  int _currentAsyncPage = 0;

  /// Whether additional async pages are available.
  bool _hasMoreAsyncResults = false;

  /// Token used to ignore stale async pagination responses.
  int _paginationRequestId = 0;

  /// Whether popup is currently open.
  bool _isOpen = false;

  /// Measured field width used as popup-width fallback.
  double? _fieldWidth;

  @override
  void initState() {
    super.initState();
    _configureTextEditingController();
    _configureFocusNode();
    _syncSelectionFromConfiguration(resetText: true);
    _resetAsyncPaginationState();
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
            suffixIcon: _buildTrailingButtons(),
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
            suffixIcon: _buildTrailingButtons(),
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

        final configuredWidth =
            widget.configuration.popupConfig.width ?? _fieldWidth;
        final placement = _resolvePopupPlacement(
          overlayContext: context,
          targetRect: targetRect,
          configuredWidth: configuredWidth,
        );
        if (placement == null) {
          return const SizedBox.shrink();
        }
        final popupConfig = _resolvedPopupConfig(placement.maxHeight);

        return Stack(
          children: [
            Positioned(
              left: placement.left,
              top: placement.top,
              width: placement.width,
              child: TapRegion(
                groupId: _tapRegionGroupId,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: placement.width),
                  child: AutocompletePopup<T>(
                    options: _visibleOptions,
                    query: _controller.text,
                    getOptionLabel: widget.configuration.getOptionLabel,
                    isSelected: _isOptionSelected,
                    onOptionTap: _selectOption,
                    popupConfig: popupConfig,
                    selectionConfig: widget.configuration.selectionConfig,
                    groupingConfig: widget.configuration.groupingConfig,
                    renderingConfig: widget.configuration.renderingConfig,
                    isLoading: _isLoading,
                    highlightedOption: _highlightedOption,
                    createInput: _createOptionInput,
                    isOptionDisabled: widget.configuration.isOptionDisabled,
                    createLabel: _createOptionInput == null
                        ? null
                        : _config.creatableConfig?.createLabel?.call(
                            _createOptionInput!,
                          ),
                    onCreateTap: _handleCreateOption,
                    createOptionBuilder: widget
                        .configuration.creatableConfig?.createOptionBuilder,
                    onReachedListEnd: _paginationConfig != null
                        ? _handlePopupReachedEnd
                        : null,
                    loadMoreTriggerOffset:
                        _paginationConfig?.loadMoreTriggerOffset ?? 120,
                    isLoadingMore: _isLoadingMore,
                    hasMoreResults: _hasMoreAsyncResults,
                    loadingMoreBuilder: _paginationConfig?.loadingMoreBuilder,
                    endOfListBuilder: _paginationConfig?.endOfListBuilder,
                    showEndOfListIndicator:
                        _paginationConfig?.showEndOfListIndicator ?? false,
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

  /// Returns popup config with runtime-constrained [maxHeight].
  AutocompletePopupConfig _resolvedPopupConfig(double maxHeight) {
    final current = widget.configuration.popupConfig;
    return AutocompletePopupConfig(
      maxHeight: maxHeight,
      width: current.width,
      elevation: current.elevation,
      padding: current.padding,
      borderRadius: current.borderRadius,
      offset: current.offset,
      emptyStateHeight: current.emptyStateHeight,
      backgroundColor: current.backgroundColor,
      heightAnimationDuration: current.heightAnimationDuration,
    );
  }

  /// Short alias for current widget configuration.
  AutocompleteFieldConfiguration<T> get _config => widget.configuration;

  /// Optional async pagination configuration for current field mode.
  AutocompleteAsyncPaginationConfig<T>? get _paginationConfig =>
      _config.asyncConfig?.paginationConfig;

  /// Whether query changes should issue new async requests.
  bool get _reloadOnQueryChange =>
      _config.asyncConfig?.reloadOnQueryChange ?? true;

  /// Source option list before query filtering.
  List<T> get _allOptions {
    if (_config.isAsync) {
      return _asyncOptions;
    }
    return <T>[...?_config.options];
  }

  /// Option list visible in the popup after query and config filtering.
  List<T> get _visibleOptions {
    final query = _controller.text;
    if (!_shouldShowOptionsForQuery(query)) {
      return const [];
    }
    if (_config.isAsync && _isDebouncing) {
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

  /// Option treated as highlighted when auto-highlight is enabled.
  T? get _highlightedOption {
    if (!_config.behaviorConfig.autoHighlight || _visibleOptions.isEmpty) {
      return null;
    }
    return _visibleOptions.first;
  }

  /// Input candidate for the synthetic creatable option, if available.
  ///
  /// Returns `null` when creatable behavior is disabled or creation is not
  /// allowed by the current query/selection/configuration.
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
    if (!_config.isMultiple &&
        _selectedValue != null &&
        _matchesInput(_selectedValue as T, rawInput)) {
      return null;
    }
    if (creatable.shouldShowCreateOption != null &&
        !creatable.shouldShowCreateOption!(rawInput, _allOptions)) {
      return null;
    }
    return rawInput;
  }

  /// Whether the popup should be rendered for the current state.
  bool get _shouldRenderPopup {
    if (!_isOpen) {
      return false;
    }
    if (_isLoading) {
      return true;
    }
    return _visibleOptions.isNotEmpty ||
        _createOptionInput != null ||
        _shouldShowEmptyState;
  }

  /// Initializes the effective text controller.
  void _configureTextEditingController() {
    _ownsController = widget.configuration.controller == null;
    _controller = widget.configuration.controller ?? TextEditingController();
  }

  /// Initializes the effective focus node and listener.
  void _configureFocusNode() {
    _ownsFocusNode = widget.configuration.focusNode == null;
    _focusNode = widget.configuration.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  /// Initializes async controller when async mode is enabled.
  void _configureAsyncController() {
    if (!_config.isAsync) {
      return;
    }
    final pagination = _paginationConfig;
    _asyncController = AsyncOptionsController<T>(
      config: _config.asyncConfig!,
      optionsBuilderOverride: pagination == null
          ? null
          : (query) => pagination.optionsPageBuilder(
                query,
                pagination.initialPage,
                pagination.pageSize,
              ),
      onUpdate: (update) {
        if (!mounted || update.query != _controller.text) {
          return;
        }
        final pagination = _paginationConfig;
        setState(() {
          _isDebouncing = false;
          _asyncOptions = update.options;
          _isLoading = update.isLoading;
          if (!update.isLoading) {
            _hasLoadedAsyncOptions = true;
          }
          if (!update.isLoading && pagination != null) {
            _currentAsyncPage = pagination.initialPage;
            _hasMoreAsyncResults = _resolveHasMore(
              page: update.options,
              pagination: pagination,
            );
            _isLoadingMore = false;
          }
        });
        _syncOverlayVisibility();
      },
    );
  }

  /// Replaces controller when external controller reference changes.
  void _replaceController(TextEditingController? oldController) {
    if (_ownsController) {
      _controller.dispose();
    }
    _configureTextEditingController();
    _syncSelectionFromConfiguration(resetText: true);
  }

  /// Replaces focus node when external focus-node reference changes.
  void _replaceFocusNode(FocusNode? oldFocusNode) {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _configureFocusNode();
  }

  /// Synchronizes local selected state from parent configuration.
  ///
  /// When [resetText] is `true`, input text is normalized to match selected
  /// state according to mode-specific behavior.
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

  /// Handles focus transitions and open/close behavior.
  void _handleFocusChange() {
    if (!mounted) {
      return;
    }

    if (_focusNode.hasFocus) {
      if (_shouldLoadAsyncOnFocus) {
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

  /// Handles query text changes from the input widget.
  void _handleInputChanged(String value) {
    if (_config.isAsync) {
      _requestAsyncOptions();
    }
    _syncOverlayVisibility(forceOpen: _focusNode.hasFocus);
    setState(() {});
  }

  /// Clears query and selection according to current mode.
  ///
  /// Side effects:
  /// - emits `onChanged`/`onValuesChanged`;
  /// - may trigger async reload on focused async fields;
  /// - re-evaluates popup visibility.
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

  /// Requests async options for the current query.
  ///
  /// Respects [AutocompleteAsyncConfig.minQueryLength],
  /// [AutocompleteAsyncConfig.loadOnFocus], and debounce settings.
  void _requestAsyncOptions({bool immediate = false}) {
    final query = _controller.text;
    final asyncConfig = _config.asyncConfig!;
    _paginationRequestId += 1;
    _isLoadingMore = false;

    if (!_reloadOnQueryChange && _hasLoadedAsyncOptions) {
      setState(() {
        _isDebouncing = false;
        _isLoading = false;
      });
      return;
    }

    final meetsMinimum = query.length >= asyncConfig.minQueryLength;
    final allowEmptyFocusLoad = query.isEmpty && asyncConfig.loadOnFocus;
    if (!meetsMinimum && !allowEmptyFocusLoad) {
      _asyncController?.cancel();
      setState(() {
        if (_reloadOnQueryChange || !_hasLoadedAsyncOptions) {
          _asyncOptions = const [];
        }
        _isLoading = false;
        _isDebouncing = false;
        if (_reloadOnQueryChange || !_hasLoadedAsyncOptions) {
          _resetAsyncPaginationState();
        }
      });
      return;
    }

    final shouldDebounce =
        !immediate && asyncConfig.debounceDuration > Duration.zero;
    setState(() {
      _isDebouncing = shouldDebounce;
      _hasMoreAsyncResults = false;
      if (!shouldDebounce && !asyncConfig.retainPreviousOptionsWhileLoading) {
        _asyncOptions = const [];
      }
    });

    _asyncController?.request(
      query,
      currentOptions: _asyncOptions,
      immediate: immediate,
    );
  }

  /// Selects [option], with optional toggle behavior for already-selected rows.
  void _selectOption(T option) {
    if (_config.behaviorConfig.toggleSelectionOnTap &&
        _isOptionSelected(option)) {
      _deselectOption(option);
      return;
    }

    if (_config.isMultiple) {
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

  /// Creates and selects a synthetic option from the current query.
  void _handleCreateOption() {
    final input = _createOptionInput;
    if (input == null) {
      return;
    }

    final creatable = _config.creatableConfig as AutocompleteCreatableConfig<T>;
    final created = creatable.createOption(input);

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

  /// Applies post-selection focus/open behavior.
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

  /// Deselects [option] from the current selection set.
  void _deselectOption(T option) {
    if (_config.isMultiple) {
      if (_isFixedChip(option)) {
        return;
      }
      final nextValues = _selectedValues
          .where((item) => !_isEqual(item, option))
          .toList(growable: false);
      setState(() {
        _selectedValues = nextValues;
        if (_config.behaviorConfig.clearInputOnSelect) {
          _controller.clear();
        }
      });
      _config.onValuesChanged?.call(List<T>.unmodifiable(nextValues));
    } else {
      setState(() {
        _selectedValue = null;
        _controller.clear();
      });
      _config.onChanged?.call(null);
    }
    _afterSelection();
  }

  /// Removes [value] via chip delete interactions.
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

  /// Handles taps outside the field/popup region.
  void _handleTapOutside() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      _closePopup();
    }
  }

  /// Opens or closes popup based on current state predicates.
  void _syncOverlayVisibility({bool forceOpen = false}) {
    final shouldOpen = (forceOpen || _focusNode.hasFocus) &&
        (_isLoading ||
            _isLoadingMore ||
            _visibleOptions.isNotEmpty ||
            _createOptionInput != null ||
            _shouldShowEmptyState);
    if (shouldOpen) {
      _openPopup();
    } else {
      _closePopup();
    }
  }

  /// Whether empty state should be rendered for the current query/state.
  bool get _shouldShowEmptyState {
    if (_isLoading) {
      return false;
    }
    if (_isDebouncing) {
      return false;
    }
    final query = _controller.text;
    if (!_shouldShowOptionsForQuery(query)) {
      return false;
    }
    if (_visibleOptions.isNotEmpty || _createOptionInput != null) {
      return false;
    }
    if (!_config.isAsync) {
      return true;
    }
    final asyncConfig = _config.asyncConfig!;
    final meetsMinimum = query.length >= asyncConfig.minQueryLength;
    final allowEmptyFocusLoad = query.isEmpty && asyncConfig.loadOnFocus;
    return meetsMinimum || allowEmptyFocusLoad;
  }

  /// Opens popup overlay if closed.
  void _openPopup() {
    if (_isOpen) {
      return;
    }
    _overlayController.show();
    setState(() {
      _isOpen = true;
    });
  }

  /// Closes popup overlay if open.
  void _closePopup() {
    if (!_isOpen) {
      return;
    }
    _overlayController.hide();
    setState(() {
      _isOpen = false;
    });
  }

  /// Whether options should be shown for [query].
  bool _shouldShowOptionsForQuery(String query) {
    if (_config.behaviorConfig.showOptionsOnEmptyInput) {
      return true;
    }
    return query.trim().isNotEmpty;
  }

  /// Returns whether [option] is currently selected.
  bool _isOptionSelected(T option) {
    if (_config.isMultiple) {
      return _selectedValues.any((selected) => _isEqual(option, selected));
    }
    return _selectedValue != null && _isEqual(option, _selectedValue as T);
  }

  /// Returns whether [input] matches any option in [options].
  bool _matchesExistingOption(String input, List<T> options) {
    return options.any((option) => _matchesInput(option, input));
  }

  /// Returns whether [option] label matches [input] per creatable config.
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

  /// Compares two options with custom equality when provided.
  bool _isEqual(T option, T value) {
    return _config.isOptionEqualToValue?.call(option, value) ?? option == value;
  }

  /// Returns whether [value] is configured as a non-removable fixed chip.
  bool _isFixedChip(T value) {
    final chipConfig = _config.chipConfig;
    if (chipConfig == null) {
      return false;
    }
    return chipConfig.fixedValues.any((item) => _isEqual(item, value));
  }

  /// Clears/normalizes query text when the field loses focus.
  void _clearQueryOnBlur() {
    if (_config.isMultiple || _selectedValue == null) {
      _controller.clear();
      return;
    }
    _controller.text = _config.getOptionLabel(_selectedValue as T);
  }

  /// Measures rendered field width for popup alignment.
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

  /// Resolves field bounds in overlay coordinate space.
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

  /// Computes popup placement while honoring viewport and keyboard insets.
  ///
  /// Returns `null` when no usable space exists above or below the field.
  _PopupPlacement? _resolvePopupPlacement({
    required BuildContext overlayContext,
    required Rect targetRect,
    required double? configuredWidth,
  }) {
    final overlayRenderObject =
        Overlay.of(overlayContext).context.findRenderObject();
    if (overlayRenderObject is! RenderBox) {
      return null;
    }

    final mediaQuery = MediaQuery.maybeOf(overlayContext);
    const viewportMargin = 4.0;
    final safeTop = (mediaQuery?.padding.top ?? 0) + viewportMargin;
    final safeBottom = overlayRenderObject.size.height -
        (mediaQuery?.viewInsets.bottom ?? 0) -
        viewportMargin;
    if (safeBottom <= safeTop) {
      return null;
    }

    final popupWidth = configuredWidth ??
        targetRect.width.clamp(0, overlayRenderObject.size.width).toDouble();
    final maxAllowedWidth =
        (overlayRenderObject.size.width - (viewportMargin * 2))
            .clamp(0, double.infinity)
            .toDouble();
    final width = popupWidth.clamp(0, maxAllowedWidth).toDouble();
    if (width <= 0) {
      return null;
    }

    final requestedMaxHeight = _config.popupConfig.maxHeight;
    final verticalGap = _config.popupConfig.offset.dy.abs();
    final belowStart = targetRect.bottom + verticalGap;
    final aboveEnd = targetRect.top - verticalGap;
    final availableBelow = (safeBottom - belowStart).clamp(0, double.infinity);
    final availableAbove = (aboveEnd - safeTop).clamp(0, double.infinity);

    final prefersBelow = availableBelow >= requestedMaxHeight ||
        availableBelow >= availableAbove;
    final availableOnSide =
        (prefersBelow ? availableBelow : availableAbove).toDouble();
    final maxHeight = requestedMaxHeight.clamp(0, availableOnSide).toDouble();
    if (maxHeight <= 0) {
      return null;
    }

    final top =
        prefersBelow ? belowStart : targetRect.top - verticalGap - maxHeight;
    final clampedTop = top.clamp(safeTop, safeBottom - maxHeight).toDouble();

    final requestedLeft = targetRect.left + _config.popupConfig.offset.dx;
    final maxLeft = overlayRenderObject.size.width - viewportMargin - width;
    final clampedLeft = requestedLeft
        .clamp(
            viewportMargin, maxLeft < viewportMargin ? viewportMargin : maxLeft)
        .toDouble();

    return _PopupPlacement(
      left: clampedLeft,
      top: clampedTop,
      width: width,
      maxHeight: maxHeight,
    );
  }

  /// Detects whether parent-provided selection changed externally.
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

  /// List equality using configured option equality semantics.
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

  /// Builds clear button when enabled and content exists.
  Widget? _buildClearButton() {
    if (!_config.clearButtonConfig.enabled ||
        !_config.enabled ||
        _config.readOnly ||
        !_hasContentToClear) {
      return null;
    }

    if (_config.clearButtonConfig.widgetBuilder != null) {
      return _config.clearButtonConfig.widgetBuilder!(_clearField);
    }

    return IconButton(
      key: const ValueKey<String>('autocomplete-clear-button'),
      tooltip: _config.clearButtonConfig.tooltip,
      onPressed: _clearField,
      icon: _config.clearButtonConfig.icon,
    );
  }

  /// Builds dropdown indicator button when enabled.
  Widget? _buildDropdownButton() {
    if (!_config.dropdownButtonConfig.enabled || !_config.enabled) {
      return null;
    }

    final onPressed = _config.readOnly ? null : _handleDropdownButtonPressed;

    if (_config.dropdownButtonConfig.iconBuilder != null) {
      return _config.dropdownButtonConfig.iconBuilder!(
        onPressed,
        _isOpen,
      );
    }

    return IconButton(
      key: const ValueKey<String>('autocomplete-dropdown-button'),
      tooltip: _config.dropdownButtonConfig.tooltip,
      onPressed: onPressed,
      icon: _isOpen
          ? _config.dropdownButtonConfig.openIcon
          : _config.dropdownButtonConfig.closedIcon,
    );
  }

  /// Builds trailing action container with clear/dropdown buttons.
  Widget? _buildTrailingButtons() {
    final clearButton = _buildClearButton();
    final dropdownButton = _buildDropdownButton();
    if (clearButton == null && dropdownButton == null) {
      return null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (clearButton != null) clearButton,
        if (dropdownButton != null) dropdownButton,
      ],
    );
  }

  /// Whether there is visible content that can be cleared.
  bool get _hasContentToClear {
    if (_controller.text.isNotEmpty) {
      return true;
    }
    if (_config.isMultiple) {
      return _selectedValues.isNotEmpty;
    }
    return _selectedValue != null;
  }

  /// Handles dropdown indicator button presses.
  void _handleDropdownButtonPressed() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    if (_shouldLoadAsyncOnFocus) {
      _requestAsyncOptions(immediate: true);
    }

    _openPopup();
    _syncOverlayVisibility(forceOpen: true);
  }

  bool get _shouldLoadAsyncOnFocus {
    if (!_config.isAsync) {
      return false;
    }
    final asyncConfig = _config.asyncConfig!;
    if (!asyncConfig.loadOnFocus || _controller.text.isNotEmpty) {
      return false;
    }
    return !_hasLoadedAsyncOptions || _asyncOptions.isEmpty;
  }

  void _handlePopupReachedEnd() {
    if (!_config.isAsync ||
        _paginationConfig == null ||
        _isLoading ||
        _isLoadingMore ||
        _isDebouncing ||
        !_hasMoreAsyncResults) {
      return;
    }
    _loadNextAsyncPage();
  }

  Future<void> _loadNextAsyncPage() async {
    final pagination = _paginationConfig;
    if (pagination == null) {
      return;
    }

    final query = _controller.text;
    final nextPage = _currentAsyncPage + 1;
    final requestId = ++_paginationRequestId;
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextItems = await pagination.optionsPageBuilder(
        query,
        nextPage,
        pagination.pageSize,
      );
      if (!mounted ||
          requestId != _paginationRequestId ||
          query != _controller.text) {
        return;
      }
      setState(() {
        _asyncOptions = <T>[..._asyncOptions, ...nextItems];
        _currentAsyncPage = nextPage;
        _hasMoreAsyncResults = _resolveHasMore(
          page: nextItems,
          pagination: pagination,
        );
        _isLoadingMore = false;
      });
      _syncOverlayVisibility();
    } catch (_) {
      if (!mounted || requestId != _paginationRequestId) {
        return;
      }
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  bool _resolveHasMore({
    required List<T> page,
    required AutocompleteAsyncPaginationConfig<T> pagination,
  }) {
    if (pagination.hasMore != null) {
      return pagination.hasMore!(page);
    }
    return page.length >= pagination.pageSize;
  }

  void _resetAsyncPaginationState() {
    _currentAsyncPage = _paginationConfig?.initialPage ?? 0;
    _hasMoreAsyncResults = false;
    _isLoadingMore = false;
    _paginationRequestId += 1;
  }
}
