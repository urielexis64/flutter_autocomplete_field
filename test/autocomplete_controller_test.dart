import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects a single value and resets input text', () {
    final controller = AutocompleteController<String>(
      options: const ['Apple', 'Banana'],
    );

    expect(controller.selectOption('Banana'), isTrue);
    expect(controller.value, 'Banana');
    expect(controller.inputValue, 'Banana');
    expect(
      controller.lastValueChangedReason,
      AutocompleteValueChangedReason.selectOption,
    );
  });

  test('freeSolo commits typed text for String values', () {
    final controller = AutocompleteController<String>(freeSolo: true);

    controller.setInputValue('Custom');

    expect(controller.selectFreeSoloText(), isTrue);
    expect(controller.value, 'Custom');
    expect(
      controller.lastValueChangedReason,
      AutocompleteValueChangedReason.createOption,
    );
  });

  test('disabled options cannot be selected', () {
    final controller = AutocompleteController<String>(
      options: const ['08:00', '09:00'],
      getOptionDisabled: (option) => option == '08:00',
    );

    expect(controller.selectOption('08:00'), isFalse);
    expect(controller.value, isNull);
  });

  test('multiple mode adds and removes values', () {
    final controller = AutocompleteController<String>(
      options: const ['Apple', 'Banana'],
      multiple: true,
    );

    controller.selectOption('Apple');
    controller.selectOption('Banana');
    expect(controller.values, ['Apple', 'Banana']);

    expect(controller.removeSelectedValue('Apple'), isTrue);
    expect(controller.values, ['Banana']);
  });

  test('custom equality supports object values', () {
    final controller = AutocompleteController<_Film>(
      options: const [_Film(1, 'A'), _Film(2, 'A')],
      value: const _Film(1, 'A'),
      getOptionLabel: (film) => film.title,
      isOptionEqualToValue: (option, value) => option.id == value.id,
    );

    expect(controller.isOptionSelected(const _Film(1, 'Different')), isTrue);
    expect(controller.isOptionSelected(const _Film(2, 'A')), isFalse);
  });

  test('grouping coalesces duplicate group keys', () {
    final groups = groupAutocompleteOptions([
      'Apple',
      'Avocado',
      'Banana',
      'Apricot',
    ], (option) => option[0]);

    expect(groups.map((group) => group.group), ['A', 'B']);
    expect(groups.first.options, ['Apple', 'Avocado', 'Apricot']);
  });

  test('indexed grouping keeps original option indexes', () {
    final groups = groupAutocompleteOptionsWithIndexes([
      'Apple',
      'Banana',
      'Apricot',
    ], (option) => option[0]);

    expect(groups.first.group, 'A');
    expect(groups.first.options.map((entry) => entry.index), [0, 2]);
  });
}

class _Film {
  const _Film(this.id, this.title);

  final int id;
  final String title;
}
