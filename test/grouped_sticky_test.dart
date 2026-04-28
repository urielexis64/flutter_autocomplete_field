import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('group headers stick while the popup scrolls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: const ValueKey<String>('popup-host'),
              width: 320,
              child: Builder(
                builder: (context) {
                  final theme = AutocompleteThemeData.resolve(
                    Theme.of(context),
                    null,
                  );
                  return AutocompletePopup<String>(
                    options: [
                      for (var index = 0; index < 5; index++) 'A$index',
                      for (var index = 0; index < 5; index++) 'B$index',
                      for (var index = 0; index < 5; index++) 'C$index',
                    ],
                    getOptionLabel: (option) => option,
                    getOptionKey: (option) => option,
                    isOptionSelected: (_) => false,
                    isOptionDisabled: (_) => false,
                    highlightedIndex: -1,
                    inputValue: '',
                    onOptionTap: (_) {},
                    onOptionHover: (_) {},
                    theme: theme,
                    maxHeight: 120,
                    groupBy: (option) => option[0],
                    groupBuilder: (context, group, children) => Container(
                      key: ValueKey<String>('group-$group'),
                      height: 32,
                      alignment: Alignment.centerLeft,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Text('Group $group'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Group A'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -280));
    await tester.pumpAndSettle();

    final popupTop = tester
        .getTopLeft(find.byKey(const ValueKey<String>('popup-host')))
        .dy;
    final groupTop = tester
        .getTopLeft(find.byKey(const ValueKey<String>('group-B')))
        .dy;

    expect(find.text('Group B'), findsOneWidget);
    expect(groupTop, lessThan(popupTop + 16));
  });

  testWidgets('group headers are not duplicated for unsorted options', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final theme = AutocompleteThemeData.resolve(
                Theme.of(context),
                null,
              );
              return AutocompletePopup<String>(
                options: const ['Apple', 'Banana', 'Apricot'],
                getOptionLabel: (option) => option,
                getOptionKey: (option) => option,
                isOptionSelected: (_) => false,
                isOptionDisabled: (_) => false,
                highlightedIndex: -1,
                inputValue: '',
                onOptionTap: (_) {},
                onOptionHover: (_) {},
                theme: theme,
                groupBy: (option) => option[0],
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Apricot'), findsOneWidget);
  });
}
