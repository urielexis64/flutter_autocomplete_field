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
