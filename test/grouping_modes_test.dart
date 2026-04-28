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

  testWidgets('sticky headers stop after grouped options end', (tester) async {
    final options = <String>[
      ...List<String>.generate(12, (index) => 'A$index'),
      ...List<String>.generate(12, (index) => 'B$index'),
      ...List<String>.generate(12, (index) => 'C$index'),
    ];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.creatable(
          options: options,
          getOptionLabel: (option) => option,
          groupingConfig: const AutocompleteGroupingConfig<String>(
            groupBy: _groupByFirstLetter,
            stickyHeaders: true,
          ),
          popupConfig: const AutocompletePopupConfig(maxHeight: 140),
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

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    final scrollable = find.descendant(
      of: findPopupSurface(),
      matching: find.byType(CustomScrollView),
    );
    final createRow = findCreateOption('zzz');
    for (var i = 0; i < 12; i++) {
      await tester.drag(scrollable, const Offset(0, -140));
      await tester.pumpAndSettle();
    }
    await tester.pumpAndSettle();
    expect(createRow, findsOneWidget);

    final popupTop = tester.getTopLeft(findPopupSurface()).dy;

    for (final header in ['A', 'B', 'C']) {
      final headerFinder = findPopupText(header);
      if (tester.any(headerFinder)) {
        final headerTop = tester.getTopLeft(headerFinder).dy;
        expect(
          (headerTop - popupTop).abs(),
          greaterThan(2),
          reason: 'Group header $header should not remain pinned at popup top.',
        );
      }
    }
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
String _groupByFirstLetter(String value) => value[0];

List<String> _keepAllOptions(
  List<String> options,
  String query,
  String Function(String option) stringify,
) {
  return options;
}
