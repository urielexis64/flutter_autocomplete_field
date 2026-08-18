# flutter_autocomplete example

This example app is a runnable cookbook for most package features, including
external async field patching without forcing widget key resets and the
popup and selection-surface fixes documented for `0.0.8`, plus the
selected-value start-adornment flow added for `0.0.9` and the per-field
`textStyle` API added for `0.0.10`, including focused-tap popup reopening,
popup scrolling inside parent `onDrag` scroll views, stable local-multiple
popup behavior with `closeOnSelect: false`, and custom popup row background
colors.

## Run it

```bash
cd example
flutter pub get
flutter run
```

## Included use cases

1. Single select with primitive values.
2. Single select with object models and custom equality.
3. Multiple selection with chips, fixed values, and chip limits.
4. Creatable flow for user-defined tags.
5. Grouped options with custom option rows and disabled options.
6. Async search-as-type with debounce and minimum query length.
7. Async combobox mode that loads once, then filters locally.
8. Async pagination with incremental page loading.
9. Form validation and `onSaved` integration.
10. External patching for async single and async multiple fields.
11. Disabled and read-only interaction-state examples.
12. Single-select start adornment example for selected values.
13. Per-field text styling example.

Main file: [`example/lib/main.dart`](lib/main.dart)
