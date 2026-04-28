import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('single select chooses one option', (tester) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');

    expect(selected, 'Banana');
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('multiple select emits selected values', (tester) async {
    var selected = <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          onChanged: (values) => selected = values,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruits'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Apple');
    await selectPopupOption(tester, 'Banana');

    expect(selected, ['Apple', 'Banana']);
    expect(find.text('Apple'), findsAtLeastNWidgets(1));
  });

  testWidgets('clear button clears single selection', (tester) async {
    String? selected = 'Apple';

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          value: selected,
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester
        .tap(find.byKey(const ValueKey<String>('autocomplete-clear-button')));
    await tester.pumpAndSettle();

    expect(selected, isNull);
    expect(find.text('Apple'), findsNothing);
  });

  testWidgets('clear button clears multiple selections', (tester) async {
    var selected = <String>['Apple', 'Banana'];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          values: selected,
          onChanged: (values) => selected = values,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruits'),
        ),
      ),
    );

    await tester
        .tap(find.byKey(const ValueKey<String>('autocomplete-clear-button')));
    await tester.pumpAndSettle();

    expect(selected, isEmpty);
    expect(find.text('Apple'), findsNothing);
  });

  testWidgets('selected options remain visible with a selected indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruits'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Apple');

    expect(findPopupText('Apple'), findsOneWidget);
    expect(
      find.descendant(
          of: findPopupSurface(), matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );
  });

  testWidgets('async single loads options from the async builder', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 10));
              return ['Apple', 'Banana']
                  .where((option) => option.toLowerCase().contains(query))
                  .toList(growable: false);
            },
            debounceDuration: Duration.zero,
            minQueryLength: 1,
          ),
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'app');
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });

  testWidgets('async multiple supports repeated selection', (tester) async {
    var selected = <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.asyncMultiple(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 10));
              return ['Apple', 'Banana', 'Cherry'];
            },
            debounceDuration: Duration.zero,
            loadOnFocus: true,
          ),
          onChanged: (values) => selected = values,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruits'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Apple');
    await selectPopupOption(tester, 'Banana');

    expect(selected, ['Apple', 'Banana']);
  });
}
