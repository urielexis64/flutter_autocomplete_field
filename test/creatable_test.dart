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

    await tester
        .tap(find.byKey(const ValueKey<String>('autocomplete-clear-button')));
    await tester.pumpAndSettle();
    expect(selected, isNull);

    await tester.enterText(find.byType(TextField), 'Mango');
    await tester.pumpAndSettle();
    expect(find.text('Add "Mango"'), findsOneWidget);
  });
}

String _identity(String input) => input;

class Tag {
  const Tag(this.label);

  final String label;
}
