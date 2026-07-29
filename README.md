# flutter_autocomplete

Mobile-first autocomplete for Flutter with focused constructors:

- `AutocompleteField.single<T>()`
- `AutocompleteField.multiple<T>()`
- `AutocompleteField.async<T>()`
- `AutocompleteField.asyncMultiple<T>()`

The package is built for touch/virtual-keyboard UX, chip-based multiple mode, async loading, creatable options, visual grouping, and popup placement that stays stable through scrolling and viewport changes.

## Installation

```yaml
dependencies:
  flutter_autocomplete: ^0.0.8
```

```dart
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
```

## Quick start

```dart
AutocompleteField<String>.single(
  options: const ['Apple', 'Banana', 'Cherry'],
  getOptionLabel: (option) => option,
  decoration: const InputDecoration(
    labelText: 'Fruit',
    border: OutlineInputBorder(),
  ),
)
```

## What's New In 0.0.8

- Controlled local multiple fields now honor `closeOnSelect: false` without collapsing the popup after parent state updates, matching the async multiple behavior.
- `AutocompleteSelectionConfig` now supports `selectedBackgroundColor` and `unselectedBackgroundColor` for the default popup option tiles.
- The release includes regression coverage for controlled multiple popup persistence and popup row background customization, plus refreshed package docs for `0.0.8`.

## Demo

| 1) Single select (primitives) | 2) Single select (objects) | 3) Multiple chips |
| --- | --- | --- |
| ![Single select demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/1-single-select-primitives.gif) | ![Single select objects demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/2-single-select-objects.gif) | ![Multiple chips demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/3-multiple-chips.gif) |

| 4) Creatable | 5) Grouped options | 6) Async search-as-type |
| --- | --- | --- |
| ![Creatable demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/4-creatable.gif) | ![Grouped options demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/5-grouping.gif) | ![Async search demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/6-async-search.gif) |

| 7) Async combobox (load once) | 8) Async pagination | 9) Form validation |
| --- | --- | --- |
| ![Async combobox demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/7-async-combobox.gif) | ![Async pagination demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/8-async-pagination.gif) | ![Form validation demo](https://raw.githubusercontent.com/urielexis64/flutter_autocomplete_field/main/example/demo/9-form-integration.gif) |

## Constructor cheat sheet

| Constructor | Selection | Data source | Typical use |
| --- | --- | --- | --- |
| `single` | One value | Local list | Plain dropdown-like autocomplete |
| `multiple` | Many values | Local list | Chips/tag picker |
| `async` | One value | API/DB | Search-as-type or combobox |
| `asyncMultiple` | Many values | API/DB | Remote-backed chip picker |

## Use case cookbook

### 1) Single select with primitive options

```dart
AutocompleteField<String>.single(
  options: const ['Open', 'In Progress', 'Done'],
  value: status,
  onChanged: (value) => setState(() => status = value),
  getOptionLabel: (option) => option,
)
```

### 2) Single select with objects + custom equality

Use `isOptionEqualToValue` when object identity may differ.

```dart
AutocompleteField<User>.single(
  options: users,
  value: selectedUser,
  onChanged: (value) => setState(() => selectedUser = value),
  getOptionLabel: (user) => user.fullName,
  isOptionEqualToValue: (option, value) => option.id == value.id,
)
```

### 3) Multiple chips with fixed values

```dart
AutocompleteField<String>.multiple(
  options: const ['Owner', 'Reviewer', 'Approver', 'Observer'],
  values: selectedRoles,
  onChanged: (values) => setState(() => selectedRoles = values),
  getOptionLabel: (option) => option,
  chipConfig: const AutocompleteChipConfig<String>(
    fixedValues: ['Owner'],
    limitTags: 3,
    showHiddenCountChip: true,
  ),
  behaviorConfig: const AutocompleteBehaviorConfig(
    closeOnSelect: false,
    clearInputOnSelect: true,
  ),
  selectionConfig: const AutocompleteSelectionConfig<String>(
    selectedBackgroundColor: Color(0xFFE8F5E9),
    unselectedBackgroundColor: Color(0xFFFFF8E1),
  ),
)
```

### 4) Creatable options

```dart
AutocompleteField<String>.multiple(
  options: const ['bug', 'feature', 'blocked'],
  values: tags,
  onChanged: (values) => setState(() => tags = values),
  getOptionLabel: (option) => option,
  creatableConfig: AutocompleteCreatableConfig<String>(
    createOption: (input) => input.trim().toLowerCase(),
    createLabel: (input) => 'Create tag "$input"',
  ),
)
```

### 5) Grouping (visual only)

Grouping changes popup rendering only.

```dart
AutocompleteField<City>.single(
  options: cities,
  getOptionLabel: (city) => city.name,
  groupingConfig: AutocompleteGroupingConfig<City>(
    groupBy: (city) => city.country,
    sortGroups: true,
    stickyHeaders: true,
  ),
)
```

### 6) Async search-as-type

```dart
AutocompleteField<String>.async(
  asyncConfig: AutocompleteAsyncConfig<String>(
    optionsBuilder: repository.searchCities,
    debounceDuration: const Duration(milliseconds: 250),
    minQueryLength: 2,
    reloadOnQueryChange: true,
  ),
  getOptionLabel: (option) => option,
)
```

### 7) Async combobox (load once, then local filtering)

Useful when backend returns a bounded dataset.

```dart
AutocompleteField<String>.async(
  asyncConfig: AutocompleteAsyncConfig<String>(
    optionsBuilder: repository.fetchAllCities,
    loadOnFocus: true,
    reloadOnQueryChange: false,
    loadOnlyOnce: true,
    searchOnEmptyQuery: false,
    debounceDuration: Duration.zero,
  ),
  getOptionLabel: (option) => option,
)
```

### 8) Async multiple (load once)

```dart
AutocompleteField<String>.asyncMultiple(
  asyncConfig: AutocompleteAsyncConfig<String>(
    optionsBuilder: repository.fetchAllLabels,
    loadOnFocus: true,
    reloadOnQueryChange: false,
    loadOnlyOnce: true,
    searchOnEmptyQuery: false,
  ),
  values: selectedLabels,
  onChanged: (values) => setState(() => selectedLabels = values),
  getOptionLabel: (option) => option,
  behaviorConfig: const AutocompleteBehaviorConfig(
    closeOnSelect: false,
    clearInputOnSelect: true,
  ),
)
```

### 9) External patching from parent/form state

```dart
AutocompleteField<String>.asyncMultiple(
  asyncConfig: AutocompleteAsyncConfig<String>(
    optionsBuilder: repository.fetchAllLabels,
    loadOnFocus: true,
    reloadOnQueryChange: false,
    loadOnlyOnce: true,
  ),
  values: selectedLabels,
  onChanged: (values) {
    setState(() {
      selectedLabels
        ..clear()
        ..addAll(values);
    });
  },
  getOptionLabel: (option) => option,
)

// Later, patch externally without changing the widget key:
setState(() {
  selectedLabels
    ..clear()
    ..addAll(['Urgent', 'Backend']);
});
```

### 10) Async pagination

```dart
AutocompleteField<String>.async(
  asyncConfig: AutocompleteAsyncConfig<String>(
    optionsBuilder: (_) async => const [],
    loadOnFocus: true,
    paginationConfig: AutocompleteAsyncPaginationConfig<String>(
      pageSize: 20,
      optionsPageBuilder: (query, page, pageSize) {
        return repository.fetchPage(query: query, page: page, size: pageSize);
      },
      showEndOfListIndicator: true,
    ),
  ),
  getOptionLabel: (option) => option,
)
```

### 11) Form validation and save

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: Column(
    children: [
      AutocompleteField<String>.single(
        options: const ['Low', 'Medium', 'High'],
        getOptionLabel: (option) => option,
        validator: (value) => value == null ? 'Priority is required' : null,
        onSaved: (value) => priority = value,
      ),
      AutocompleteField<String>.multiple(
        options: const ['UI', 'Backend', 'QA'],
        getOptionLabel: (option) => option,
        validator: (values) {
          if (values == null || values.isEmpty) {
            return 'Select at least one team';
          }
          return null;
        },
        onSaved: (values) => teams = values ?? <String>[],
      ),
    ],
  ),
)
```

### 12) Custom rendering

```dart
AutocompleteField<String>.multiple(
  options: const ['Apple', 'Banana', 'Cherry'],
  getOptionLabel: (option) => option,
  renderingConfig: AutocompleteRenderingConfig<String>(
    optionBuilder: (context, option) {
      return ListTile(
        title: Text(option.label),
        trailing: option.isSelected
            ? const Icon(Icons.check, size: 18)
            : null,
      );
    },
  ),
)
```

### 13) Disabled options

```dart
AutocompleteField<String>.single(
  options: const ['Open', 'Closed', 'Archived'],
  getOptionLabel: (option) => option,
  isOptionDisabled: (option) => option == 'Archived',
)
```

### 14) Disabled vs read-only interaction states

Use `enabled: false` when the field should be disabled and excluded from normal form interaction. Use `readOnly: true` when it should keep enabled styling but block edits, popup selection changes, clearing, and chip deletion.

```dart
AutocompleteField<String>.multiple(
  options: const ['Apple', 'Banana', 'Cherry'],
  values: const ['Apple', 'Banana'],
  onChanged: (_) {},
  readOnly: true,
  getOptionLabel: (option) => option,
  decoration: const InputDecoration(
    labelText: 'Locked fruit list',
    helperText: 'Users can review the values, but cannot change them.',
    border: OutlineInputBorder(),
  ),
)
```

## Async behavior reference

`AutocompleteAsyncConfig` gives these common patterns:

- Search-as-type: `reloadOnQueryChange: true`
- Load on focus: `loadOnFocus: true`
- One request only: `loadOnlyOnce: true`
- Ignore whitespace-only input: `searchOnEmptyQuery: false`
- Local filtering after first load: `reloadOnQueryChange: false`

## Useful config groups

- `AutocompleteBehaviorConfig`: focus/open/close/clear behavior.
- `AutocompleteFilterConfig`: matching strategy and custom filter.
- `AutocompleteSelectionConfig`: keep selected rows visible, customize selected and unselected row backgrounds, and control indicator behavior.
- `AutocompleteChipConfig`: chip layout, fixed values, hidden count, max chip area height.
- `AutocompletePopupConfig`: popup size/surface styling.
- `AutocompleteRenderingConfig`: option/selected/loading/empty custom builders.

## Example app

A full runnable showcase exists in `example/lib/main.dart`.

It includes:

1. Single and multiple local constructors.
2. Creatable and grouped flows.
3. Async search-as-type.
4. Async load-once combobox and async multiple.
5. Async pagination.
6. Form validation and save flows.
7. Disabled and read-only interaction state examples.

## Accessibility and platform scope

- Uses Flutter text/chip/tap semantics.
- Validation errors are rendered via `InputDecoration`.
- Mobile-first behavior.
