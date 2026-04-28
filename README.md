# flutter_autocomplete

A reusable Flutter autocomplete field inspired by MUI's React Autocomplete.

The widget is a normal text input enhanced by an anchored options panel. It supports combo-box selection from predefined options and `freeSolo` text entry, with separate selected value and input text state, multiple selection, chips, grouping, async loading, custom filtering, custom rendering, disabled options, keyboard navigation, and large-list virtualization.

Reference behavior: [MUI Autocomplete docs](https://mui.com/material-ui/react-autocomplete/).

## Local Usage

From another package in this workspace:

```yaml
dependencies:
  flutter_autocomplete:
    path: ../flutter_autocomplete
```

Then import:

```dart
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
```

## Basic Example

```dart
AutocompleteField<String>.comboBox(
  options: const ['The Godfather', 'Pulp Fiction', 'Inception'],
  decoration: const InputDecoration(
    labelText: 'Movie',
    border: OutlineInputBorder(),
  ),
)
```

Object options should provide a label, stable key when labels can repeat, and equality logic when identity is not enough:

```dart
AutocompleteField<Movie>(
  options: movies,
  getOptionLabel: (movie) => movie.title,
  getOptionKey: (movie) => movie.id,
  isOptionEqualToValue: (option, value) => option.id == value.id,
)
```

## API Overview

`AutocompleteField<T>` is generic over the option type.

Focused constructors are available for common modes:

- `AutocompleteField<T>.comboBox(...)` for single selection from known options.
- `AutocompleteField<T>.multiple(...)` for chip/tag selection with `values`.
- `AutocompleteField<T>.freeSolo(...)` for arbitrary text entry. Prefer `AutocompleteField<String>.freeSolo`.
- `AutocompleteField<T>.async(...)` for load-on-open or search-as-you-type option loading.

The default `AutocompleteField<T>(...)` constructor remains available for advanced combinations, but the factories intentionally omit fields that do not belong to that mode.

Core state:

- `value` and `onChanged` control the selected single value.
- `values` and `onValuesChanged` control selected values in `multiple` mode.
- `inputValue` and `onInputChanged` control the text shown in the field.
- `defaultValue` and `defaultValues` seed uncontrolled selections.

Option behavior:

- `getOptionLabel` controls displayed text.
- `getOptionKey` gives duplicate-label options stable identity.
- `isOptionEqualToValue` handles object equality.
- `getOptionDisabled` leaves options visible but unselectable.
- `groupBy` coalesces matching group values with sticky headers by default, even when options are not pre-sorted.
- `groupBuilder` customizes group headers. When sticky headers are enabled it receives an empty `children` list because option rows are rendered in separate slivers.
- `filterOptions` replaces the default filter. Use `identityAutocompleteFilter` for server-filtered async results.

Rendering:

- `optionBuilder` customizes rows.
- `groupBuilder` customizes grouped headers or full grouped sections when sticky headers are disabled.
- `selectedItemBuilder` and `selectedItemsBuilder` customize selected values and chips.
- `chipBuilder` customizes individual multiple-selection chips.
- `chipLayout`, `chipMinInputWidth`, and `chipMaxWidth` control how selected chips share space with the input and suffix buttons.
- `AutocompleteThemeData` customizes popup, rows, and chip styling.

Multiple-selection chips are constrained before the suffix controls by default, so long selected labels should not cover the clear/dropdown buttons. Tapping the chip area also focuses the field.
In multiple mode, selecting an option keeps the input focused and the popup open when `blurOnSelect` is `false`.

```dart
AutocompleteField<String>.multiple(
  options: const ['Apple', 'Banana', 'Cherry'],
  chipLayout: AutocompleteChipLayout.horizontalScroll,
  chipMinInputWidth: 120,
  chipLabelMaxWidth: 96,
  chipBackgroundColor: Colors.blueGrey.shade50,
  chipBuilder: (context, value, state) {
    return InputChip(
      label: Text(value),
      onDeleted: state.onRemove,
    );
  },
)
```

## MUI Prop Mapping

| MUI concept | Flutter equivalent |
| --- | --- |
| `options` | `options` |
| `value` / `onChange` | `value` / `onChanged` |
| `inputValue` / `onInputChange` | `inputValue` / `onInputChanged` |
| `multiple` | `multiple` |
| `freeSolo` | `freeSolo` |
| `getOptionLabel` | `getOptionLabel` |
| `getOptionKey` | `getOptionKey` |
| `isOptionEqualToValue` | `isOptionEqualToValue` |
| `getOptionDisabled` | `getOptionDisabled` |
| `groupBy` / `renderGroup` | `groupBy` / `groupBuilder` |
| sticky grouped headers | `stickyGroupHeaders`, `groupHeaderHeight` |
| `filterOptions` | `filterOptions` |
| `createFilterOptions` | `createAutocompleteFilter` |
| `filterSelectedOptions` | `filterSelectedOptions` |
| `renderOption` | `optionBuilder` |
| `renderValue` | `selectedItemBuilder`, `selectedItemsBuilder` |
| `limitTags` | `limitTags` |
| `size="small"` | `size: AutocompleteSize.small` |
| `disableClearable` | `disableClearable` |
| `clearOnEscape` | `clearOnEscape` |
| `openOnFocus` | `openOnFocus` |
| `autoHighlight` | `autoHighlight` |
| `autoSelect` | `autoSelect` |
| `disableCloseOnSelect` | `disableCloseOnSelect` |
| `includeInputInList` | `includeInputInList` |
| `disableListWrap` | `disableListWrap` |
| `blurOnSelect` | `blurOnSelect` |
| `clearOnBlur` | `clearOnBlur` |
| `selectOnFocus` | `selectOnFocus` |
| `handleHomeEndKeys` | `handleHomeEndKeys` |
| async load on open | `loadOptionsOnOpen` |
| search as you type | `asyncOptionsBuilder` or external debounced `onInputChanged` |
| virtualized listbox | `virtualized: true` |

## Filtering

`createAutocompleteFilter<T>()` mirrors MUI's `createFilterOptions` knobs:

```dart
final filter = createAutocompleteFilter<Movie>(
  ignoreAccents: true,
  ignoreCase: true,
  limit: 100,
  matchFrom: AutocompleteFilterMatchFrom.start,
  stringify: (movie) => movie.title,
  trim: true,
);
```

Defaults are MUI-compatible: accents and case are ignored, matching is anywhere, `limit` is null, and `trim` is false.

## Advanced Examples

See `example/lib/examples` for demos covering:

- Basic combo box
- Object options with stable keys and custom equality
- Free solo search input
- Creatable "Add query" option
- Grouped options
- Disabled options
- Multiple selection with chips
- Fixed chips that cannot be removed
- Selection indicators
- `limitTags`
- Small size variant
- Async load on open
- Debounced search as you type
- Custom option rendering with highlighted text
- Custom filter matching from the start
- 10,000-option virtualized list

Run the example from the `example` directory:

```sh
fvm flutter run
```

## Accessibility Notes

The widget adds Flutter `Semantics` for the text field, expanded/collapsed hint, option selected state, disabled state, popup label, and chip delete affordances.

Flutter does not expose a one-to-one WAI-ARIA combobox/listbox role API like the web. This package follows the intent of the [WAI-ARIA combobox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/) where Flutter semantics supports it, while relying on platform text field and focus semantics for native assistive technology behavior.

## Known Differences From React/MUI

- Free-solo committed values are strings in MUI. In Dart, this package can commit typed free-solo text only when `T` can accept `String`, usually `AutocompleteField<String>`.
- Flutter overlays and semantics are platform-native, not DOM portals and ARIA attributes.
- `includeInputInList` is approximated for keyboard navigation by allowing the highlight to return to no option.
- Custom selected-value rendering is Flutter widget based. Builders receive remove callbacks instead of MUI's `getItemProps`.
- Virtualization uses Flutter's `ListView.builder`; fixed row heights are recommended for the smoothest large-list behavior.

## Assumptions and Limitations

- Grouping coalesces identical group keys and preserves the order in which each group first appears. Sorting by the grouping dimension is still recommended when you want predictable alphabetical/group order.
- `loadOptionsOnOpen` runs once per controller lifetime.
- Click-away closing is handled through focus loss; apps with unusual focus management may want to close the field explicitly by moving focus.
- Browser autofill limitations from MUI do not apply directly to Flutter, but platform text autofill can still affect UX depending on app configuration.
