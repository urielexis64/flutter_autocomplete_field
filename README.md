# flutter_autocomplete

`flutter_autocomplete` is a mobile-first autocomplete package for Flutter.

The package focuses on:

- focused constructors instead of one giant widget API
- chip-based multiple selection that works with the virtual keyboard
- visual grouping that stays separate from selection logic
- creatable flows that generate typed values instead of selecting raw text
- no physical keyboard navigation
- no desktop shortcut handling
- no virtualized lists

## Installation

```yaml
dependencies:
  flutter_autocomplete: ^0.0.1
```

```dart
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
```

## Quick Start

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

## Validation

All constructors integrate with Flutter `Form` and expose the standard form
hooks for their selection shape:

- single-value modes use `String? Function(T? value)? validator`
- multiple-value modes use `String? Function(List<T> values)? validator`
- all modes support `onSaved` and `autovalidateMode`

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: AutocompleteField<String>.multiple(
    options: const ['Apple', 'Banana', 'Cherry'],
    getOptionLabel: (option) => option,
    validator: (values) {
      if (values == null || values.isEmpty) {
        return 'Pick at least one fruit';
      }
      return null;
    },
    decoration: const InputDecoration(
      labelText: 'Fruits',
      border: OutlineInputBorder(),
    ),
  ),
)
```

## Constructor Guide

All modes are exposed through explicit constructors:

- `AutocompleteField.single<T>()`
- `AutocompleteField.multiple<T>()`
- `AutocompleteField.async<T>()`
- `AutocompleteField.asyncMultiple<T>()`

## Mode Comparison

| Constructor | Selection | Data Source | Creation |
| --- | --- | --- | --- |
| `single` | one value | sync list | optional via `creatableConfig` |
| `multiple` | many values | sync list | optional via `creatableConfig` |
| `async` | one value | async loader | optional via `creatableConfig` |
| `asyncMultiple` | many values | async loader | optional via `creatableConfig` |

## Examples

### Single Select

```dart
AutocompleteField<Movie>.single(
  options: movies,
  value: selectedMovie,
  onChanged: (movie) => setState(() => selectedMovie = movie),
  getOptionLabel: (movie) => movie.title,
  decoration: const InputDecoration(
    labelText: 'Movie',
    border: OutlineInputBorder(),
  ),
)
```

### Multiple Select

```dart
AutocompleteField<String>.multiple(
  options: const ['Apple', 'Banana', 'Cherry', 'Dragonfruit'],
  values: selectedFruits,
  onChanged: (values) => setState(() => selectedFruits = values),
  getOptionLabel: (option) => option,
  decoration: const InputDecoration(
    labelText: 'Fruits',
    border: OutlineInputBorder(),
  ),
)
```

### Async

```dart
AutocompleteField<String>.async(
  asyncConfig: AutocompleteAsyncConfig(
    optionsBuilder: repository.searchCities,
    debounceDuration: const Duration(milliseconds: 250),
    minQueryLength: 2,
  ),
  getOptionLabel: (option) => option,
  decoration: const InputDecoration(
    labelText: 'City',
    border: OutlineInputBorder(),
  ),
)
```

## Grouping

Grouping changes popup rendering only. It does not change selection, equality, or stored values.

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

Creatable rows are rendered outside groups, so the synthetic create action stays distinct from grouped options.

## Custom Filtering

```dart
AutocompleteField<Movie>.single(
  options: movies,
  getOptionLabel: (movie) => movie.title,
  filterConfig: AutocompleteFilterConfig<Movie>(
    matchFrom: AutocompleteMatchFrom.start,
    limit: 20,
    stringify: (movie) => '${movie.title} ${movie.director}',
  ),
)
```

When async results are already filtered by the server, provide `filterOptions` and return the input list unchanged.

## Custom Rendering

```dart
AutocompleteField<String>.multiple(
  options: const ['Apple', 'Banana', 'Cherry'],
  getOptionLabel: (option) => option,
  renderingConfig: AutocompleteRenderingConfig<String>(
    optionBuilder: (context, option) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(option.label)),
            if (option.isSelected) const Icon(Icons.check, size: 18),
          ],
        ),
      );
    },
  ),
)
```

## Theming

The package intentionally leans on Flutter theming primitives:

- use `InputDecoration` for the field container and labels
- use `AutocompletePopupConfig` for popup size and surface styling
- use `AutocompleteChipConfig` for chip spacing, limits, and delete affordances
- use `AutocompleteRenderingConfig` when you need fully custom rows or chips

`AutocompleteChipConfig` also supports focused-state tag limiting and capped
chip/input area growth:

- `limitTagsWhenFocused` keeps `limitTags` applied while typing
- `showHiddenCountChip` controls the `+N` summary indicator
- `maxInputAreaHeight` enables internal scrolling past a height limit

## Accessibility Notes

- The package uses Flutter text field, chip, and tap semantics instead of web ARIA roles.
- Group headers are visual only.
- Creatable rows are explicit actions, not implicit raw-text selections.
- Validation errors render through the field `InputDecoration`.
- Keyboard shortcuts and arrow-key navigation are intentionally unsupported.

## Mobile Behavior Notes

- Tapping the field focuses the input.
- Tapping an option selects it.
- Tapping a creatable row creates a new typed value and selects it.
- Tapping outside the field closes the popup.
- The package is designed for virtual-keyboard-first layouts.

## Layout Notes

Multiple mode uses:

- `InputDecorator` as the outer field container
- a `Wrap` for chips and the text input
- a borderless inner `TextField`

This allows:

- vertical growth instead of overflow
- label floating based on focus, chips, and input text
- tap-anywhere focusing
- mobile-friendly chip entry without `prefix` or `prefixIcon`

## No Keyboard Support

This package does not implement:

- physical keyboard shortcuts
- arrow key navigation
- enter or escape handling
- home or end handling
- desktop-specific interaction patterns
- virtualized option rendering
