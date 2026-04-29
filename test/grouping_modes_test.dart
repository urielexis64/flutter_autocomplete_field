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

  testWidgets('group headers are sticky by default', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Apricot', 'Banana'],
          getOptionLabel: (option) => option,
          groupingConfig: AutocompleteGroupingConfig<String>(
            groupBy: (option) => option[0],
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.byType(SliverMainAxisGroup), findsAtLeastNWidgets(1));
    expect(find.byType(SliverPersistentHeader), findsAtLeastNWidgets(1));
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
}
