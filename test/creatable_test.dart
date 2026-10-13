import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows a create row when the input does not match options', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();

    expect(find.text('Add "Mango"'), findsOneWidget);
  });

  testWidgets('does not show a create row for an existing option', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Apple');
    await tester.pumpAndSettle();

    expect(find.text('Add "Apple"'), findsNothing);
  });

  testWidgets('does not show a create row when the label is already selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          values: const ['Mango'],
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();

    expect(find.text('Add "Mango"'), findsNothing);
  });

  testWidgets('async constructor supports creatable values', (tester) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig<String>(
            optionsBuilder: (query) async => const ['Apple', 'Banana'],
            debounceDuration: Duration.zero,
          ),
          filterConfig: const AutocompleteFilterConfig<String>(enabled: true),
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await selectCreateOption(tester, 'Mango');

    expect(selected, 'Mango');
    expect(find.text('Mango'), findsOneWidget);
  });

  testWidgets('created options are not retained after deselection', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await selectCreateOption(tester, 'Mango');
    expect(selected, 'Mango');

    await tester.tap(
      find.byKey(const ValueKey<String>('autocomplete-clear-button')),
    );
    await tester.pumpAndSettle();
    expect(selected, isNull);

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    expect(find.text('Add "Mango"'), findsOneWidget);
  });

  testWidgets('keyboard submit creates the typed value in single mode', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(selected, 'Mango');
    expect(find.text('Mango'), findsOneWidget);
    expect(find.text('Add "Mango"'), findsNothing);
  });

  testWidgets('keyboard submit creates the typed value in multiple mode', (
    tester,
  ) async {
    var values = const <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          onChanged: (next) => values = next,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(values, const ['Mango']);
    expect(find.widgetWithText(InputChip, 'Mango'), findsOneWidget);
  });

  testWidgets('async constructor creates values on keyboard submit', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig<String>(
            optionsBuilder: (query) async => const ['Apple', 'Banana'],
            debounceDuration: Duration.zero,
          ),
          filterConfig: const AutocompleteFilterConfig<String>(enabled: true),
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(selected, 'Mango');
  });

  testWidgets('keyboard submit does not create an existing option', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Apple');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(selected, isNull);
  });

  testWidgets('keyboard submit respects minInputLength', (tester) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
            minInputLength: 4,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Man');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(selected, isNull);
  });

  testWidgets('keyboard submit does not create when createOnSubmit is false', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
            createOnSubmit: false,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    expect(find.text('Add "Mango"'), findsOneWidget);

    await submitAutocompleteInput(tester);

    expect(selected, isNull);
  });

  testWidgets('keyboard submit forwards onSubmitted after creating', (
    tester,
  ) async {
    String? selected;
    String? submitted;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          onSubmitted: (value) => submitted = value,
          getOptionLabel: (option) => option,
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    await submitAutocompleteInput(tester);

    expect(selected, 'Mango');
    expect(submitted, 'Mango');
  });

  testWidgets('textInputAction reaches the internal text fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          textInputAction: TextInputAction.send,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    expect(
      tester.widget<TextField>(find.byType(TextField)).textInputAction,
      TextInputAction.send,
    );
  });
}

/// Test helper used as `createOption` for `String` creatable scenarios.
String _identity(String input) => input;

/// Simple model used to validate generic creatable type support in tests.
class Tag {
  /// Creates a [Tag] with display [label].
  const Tag(this.label);

  /// Human-readable tag label.
  final String label;
}
