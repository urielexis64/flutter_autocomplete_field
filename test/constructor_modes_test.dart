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

  testWidgets('dropdown indicator is visible by default', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('autocomplete-dropdown-button')),
      findsOneWidget,
    );
  });

  testWidgets('tapping the dropdown indicator opens the popup', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('autocomplete-dropdown-button')),
    );
    await tester.pumpAndSettle();

    expect(findPopupSurface(), findsOneWidget);
    expect(findPopupText('Apple'), findsOneWidget);
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

  testWidgets('multiple mode can toggle selected option off on tap', (
    tester,
  ) async {
    var selected = <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          onChanged: (values) => selected = values,
          getOptionLabel: (option) => option,
          behaviorConfig: const AutocompleteBehaviorConfig(
            closeOnSelect: false,
            clearInputOnSelect: true,
            toggleSelectionOnTap: true,
          ),
          decoration: const InputDecoration(labelText: 'Fruits'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Apple');
    expect(selected, ['Apple']);

    await selectPopupOption(tester, 'Apple');
    expect(selected, isEmpty);
  });

  testWidgets('single mode can clear selected option by tapping again', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          onChanged: (value) => selected = value,
          getOptionLabel: (option) => option,
          behaviorConfig: const AutocompleteBehaviorConfig(
            toggleSelectionOnTap: true,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');
    expect(selected, 'Banana');

    await tester.tap(
      find.byKey(const ValueKey<String>('autocomplete-dropdown-button')),
    );
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');

    expect(selected, isNull);
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

  testWidgets('single validator shows an error through the input decoration', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      buildTestApp(
        Form(
          key: formKey,
          child: AutocompleteField<String>.single(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            validator: (value) => value == null ? 'Select a fruit' : null,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();

    expect(find.text('Select a fruit'), findsOneWidget);
  });

  testWidgets('multiple validator validates selected values', (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      buildTestApp(
        Form(
          key: formKey,
          child: AutocompleteField<String>.multiple(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            validator: (values) => values == null || values.isEmpty
                ? 'Pick at least one fruit'
                : null,
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();
    expect(find.text('Pick at least one fruit'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Apple');

    expect(formKey.currentState!.validate(), isTrue);
  });

  testWidgets('onSaved receives the selected value', (tester) async {
    final formKey = GlobalKey<FormState>();
    String? savedValue;

    await tester.pumpWidget(
      buildTestApp(
        Form(
          key: formKey,
          child: AutocompleteField<String>.single(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            onSaved: (value) => savedValue = value,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');

    formKey.currentState!.save();
    expect(savedValue, 'Banana');
  });
}
