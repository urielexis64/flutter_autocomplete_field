import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  final grouping = AutocompleteGroupingConfig<String>(
    groupBy: (option) => option[0],
    stickyHeaders: true,
  );

  testWidgets('grouping works in single mode', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Apricot', 'Banana'],
          getOptionLabel: (option) => option,
          groupingConfig: grouping,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('grouping works in multiple mode', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Apricot', 'Banana'],
          values: const ['Apple'],
          getOptionLabel: (option) => option,
          groupingConfig: grouping,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('Apple'), findsAtLeastNWidgets(1));
  });

  testWidgets('grouping works in async mode', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async => const [
              'Amsterdam',
              'Athens',
              'Berlin',
            ],
            debounceDuration: Duration.zero,
            loadOnFocus: true,
          ),
          getOptionLabel: (option) => option,
          groupingConfig: grouping,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('creatable rows render outside grouped options', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.creatable(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          groupingConfig: grouping,
          filterConfig: AutocompleteFilterConfig<String>(
            filterOptions: _keepAllOptions,
          ),
          creatableConfig: const AutocompleteCreatableConfig<String>(
            createOption: _identity,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Kiwi');
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('Add "Kiwi"'), findsOneWidget);
  });
}

String _identity(String input) => input;

List<String> _keepAllOptions(
  List<String> options,
  String query,
  String Function(String option) stringify,
) {
  return options;
}
