# flutter_autocomplete

Mobile-first autocomplete for Flutter with focused constructors:

- `AutocompleteField.single<T>()`
- `AutocompleteField.multiple<T>()`
- `AutocompleteField.async<T>()`
- `AutocompleteField.asyncMultiple<T>()`

The package is built for touch/virtual-keyboard UX, chip-based multiple mode, async loading, creatable options, and visual grouping.

## Installation

```yaml
dependencies:
  flutter_autocomplete: ^0.0.1
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

## Demo

Use this section to showcase real UI behavior per use case.  
For pub.dev, the most reliable pattern is:

- A GIF/image preview (`![...](...)`)

### Ready-to-fill demo blocks

| 1) Single select (primitives) | 2) Single select (objects) | 3) Multiple chips |
| --- | --- | --- |
| ![Single select demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/1%20Single%20select%20primitives.gif) | ![Single select objects demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/2%20Single%20select%20objects.gif) | ![Multiple chips demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/3%20Multiple%20chips.gif) |

| 4) Creatable | 5) Grouped options | 6) Async search-as-type |
| --- | --- | --- |
| ![Creatable demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/4%20Creatable.gif) | ![Grouped options demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/5%20Grouping.gif) | ![Async search demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/6%20Async%20search.gif) |

| 7) Async combobox (load once) | 8) Async pagination | 9) Form validation |
| --- | --- | --- |
| ![Async combobox demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/7%20Async%20combobox.gif) | ![Async pagination demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/8%20Async%20Pagination.gif) | ![Form validation demo](https://github.com/urielexis64/flutter_autocomplete_field/blob/main/example/demo/9%20Form%20Integration.gif) |

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
)
```

### 9) Async pagination

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

### 10) Form validation and save

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

### 11) Custom rendering

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

### 12) Disabled options

```dart
AutocompleteField<String>.single(
  options: const ['Open', 'Closed', 'Archived'],
  getOptionLabel: (option) => option,
  isOptionDisabled: (option) => option == 'Archived',
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
- `AutocompleteSelectionConfig`: keep selected rows visible and indicator behavior.
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

## Accessibility and platform scope

- Uses Flutter text/chip/tap semantics.
- Validation errors are rendered via `InputDecoration`.
- Mobile-first behavior.
- Physical keyboard shortcut/navigation behavior is intentionally out of scope.
