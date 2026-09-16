# flutter_autocomplete example

This example app is a runnable cookbook for most package features, including
the `0.0.11` async behavior that preserves complete remote results unless
client-side filtering is explicitly enabled, plus expandable hidden-count
chips that reveal all selected values without focusing the field. It also
covers external async field patching, focused-tap popup reopening, popup
scrolling inside parent `onDrag` scroll views, stable local-multiple popup
behavior with `closeOnSelect: false`, custom popup row background colors,
selected-value start adornments, and per-field input text styling.

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
