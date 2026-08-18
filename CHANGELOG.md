## 0.0.10

* Added a `textStyle` parameter to all `AutocompleteField` constructors so the internal input text can be styled per widget without relying on a surrounding theme override.
* Applied `textStyle` consistently across single, multiple, async, and async-multiple input renderers, including the embedded text field used inside chip-based multiple mode.
* Added regression coverage for single and multiple text-style forwarding, and refreshed package docs/example metadata for `0.0.10`.

## 0.0.9

* Added `startAdornmentBuilder` to `AutocompleteRenderingConfig` so single-select fields can render a selected-value widget at the start of the input without replacing the underlying `TextField`.
* Kept the single-field `TextField` mounted when using a start adornment, including async focus/loading flows where the popup opens and remote options refresh.
* Refreshed package docs and the example cookbook for the `0.0.9` release, including a selected-value start-adornment example.

## 0.0.8

* Fixed controlled synchronous multiple-selection fields so `closeOnSelect: false` keeps the popup open after selection just like `asyncMultiple`, instead of recreating the internal form field and dropping popup state.
* Added `selectedBackgroundColor` and `unselectedBackgroundColor` to `AutocompleteSelectionConfig` so the default popup option tile backgrounds can be customized without supplying a custom option builder.
* Added regression coverage for controlled local-multiple popup persistence and popup row background customization, and refreshed release docs/example metadata for `0.0.8`.

## 0.0.7

* Fixed popup scrolling inside parent `SingleChildScrollView` widgets that use `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`, so dragging the autocomplete popup no longer dismisses focus and closes the overlay.
* Preserved popup pagination/load-more notification handling while preventing popup scroll notifications from bubbling into ancestor scroll views.
* Added regression coverage for popup scrolling inside `onDrag` parent scroll views and refreshed release documentation for `0.0.7`.

## 0.0.6

* Fixed popup reopening when a user taps an already-focused field after selecting an option and the popup closes.
* Applied the focused-tap reopen behavior consistently across both single and multiple autocomplete input renderers.
* Added regression coverage for single and multiple focus flows, and refreshed release documentation for `0.0.6`.

## 0.0.5

* Added `enabled` and `readOnly` support across all `AutocompleteField` constructors so disabled and immutable form states can be modeled explicitly.
* Improved popup positioning during on-screen keyboard metric changes and parent scrolling so the overlay stays attached to the field and repositions when available space changes.
* Updated package docs and the example cookbook for the `0.0.5` release, including interaction-state guidance.

## 0.0.4

* Fixed async multiple selection flows so the popup can remain open across repeated selections even when `clearInputOnSelect` clears the field.
* Fixed async single and async multiple form-field synchronization so external value patches refresh the field without forcing a widget `key` change.
* Updated package docs and the example app to demonstrate the new async patching behavior for the `0.0.4` release.

## 0.0.3

* Fixed async single-select focus loading when the field has an initial value, so tapping the field opens the overlay and fetches options as expected.
* Refreshed release metadata and installation docs for the `0.0.3` package release.

## 0.0.2+1

* Added async pagination support for remote option loading.
* Added async behavior controls: `loadOnlyOnce`, `searchOnEmptyQuery`, and local filtering after first load.
* Improved selection/popup behavior in single and multiple modes, including async refocus/select/unselect flows.
* Expanded customization options (chip layouts, option highlighting, dropdown/disabled options, popup animation).
* Improved documentation and example app with cookbook-style demos and pub.dev metadata updates.

## 0.0.1

* Initial reusable `AutocompleteField<T>` package implementation.
* Added MUI-inspired filtering, controller, popup, chips, theming, examples, and tests.
