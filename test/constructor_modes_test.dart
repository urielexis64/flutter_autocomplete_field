import 'dart:async';

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

  testWidgets(
    'single mode reopens with all options after selecting a value',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.single(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await selectPopupOption(tester, 'Banana');

      await tester.tap(find.byKey(const Key('outside-area')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(findPopupText('Apple'), findsOneWidget);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'single mode keeps selected indicator on reopen',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.single(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await selectPopupOption(tester, 'Banana');

      await tester.tap(find.byKey(const Key('outside-area')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: findPopupOption('Banana'),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: findPopupOption('Apple'),
          matching: find.byIcon(Icons.check),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'single mode marks initial object value as selected by matching label',
    (tester) async {
      final options = const [
        _City('1', 'Paris'),
        _City('2', 'London'),
      ];
      final initialValue = const _City('99', 'London');

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<_City>.single(
            options: options,
            value: initialValue,
            getOptionLabel: (option) => option.name,
            decoration: const InputDecoration(labelText: 'City'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: findPopupOption('London'),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: findPopupOption('Paris'),
          matching: find.byIcon(Icons.check),
        ),
        findsNothing,
      );
    },
  );

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

  testWidgets(
    'default option rows highlight matching query text case-insensitively',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.single(
            options: const ['Hello', 'World'],
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Greeting'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'O');
      await tester.pumpAndSettle();

      final helloText = _popupOptionLabelText(tester, 'Hello');
      final worldText = _popupOptionLabelText(tester, 'World');
      final helloSpan = helloText.textSpan as TextSpan?;
      final worldSpan = worldText.textSpan as TextSpan?;

      expect(helloSpan, isNotNull);
      expect(worldSpan, isNotNull);
      expect(helloSpan!.toPlainText(), 'Hello');
      expect(worldSpan!.toPlainText(), 'World');
      expect(helloSpan.children!.length, greaterThan(1));
      expect(worldSpan.children!.length, greaterThan(1));
    },
  );

  testWidgets('option match highlighting can be disabled', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Hello', 'World'],
          getOptionLabel: (option) => option,
          renderingConfig: const AutocompleteRenderingConfig<String>(
            highlightMatchesInDefaultOption: false,
          ),
          decoration: const InputDecoration(labelText: 'Greeting'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'o');
    await tester.pumpAndSettle();

    final helloText = _popupOptionLabelText(tester, 'Hello');
    final worldText = _popupOptionLabelText(tester, 'World');
    expect(helloText.data, 'Hello');
    expect(worldText.data, 'World');
    expect(helloText.textSpan, isNull);
    expect(worldText.textSpan, isNull);
  });

  testWidgets('option highlighting can be limited to first occurrence', (
    tester,
  ) async {
    const highlightColor = Colors.red;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Fooboo', 'World'],
          getOptionLabel: (option) => option,
          renderingConfig: const AutocompleteRenderingConfig<String>(
            highlightMatchScope:
                AutocompleteHighlightMatchScope.firstOccurrence,
            highlightedMatchTextStyle: TextStyle(color: highlightColor),
          ),
          decoration: const InputDecoration(labelText: 'Greeting'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'o');
    await tester.pumpAndSettle();

    final foobooText = _popupOptionLabelText(tester, 'Fooboo');
    expect(_countHighlightedSegments(foobooText, highlightColor), 1);
  });

  testWidgets('option highlighting can include all occurrences',
      (tester) async {
    const highlightColor = Colors.red;

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Fooboo', 'World'],
          getOptionLabel: (option) => option,
          renderingConfig: const AutocompleteRenderingConfig<String>(
            highlightMatchScope: AutocompleteHighlightMatchScope.allOccurrences,
            highlightedMatchTextStyle: TextStyle(color: highlightColor),
          ),
          decoration: const InputDecoration(labelText: 'Greeting'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'o');
    await tester.pumpAndSettle();

    final foobooText = _popupOptionLabelText(tester, 'Fooboo');
    expect(_countHighlightedSegments(foobooText, highlightColor), 4);
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

  testWidgets('loadOnFocus loads once and does not reload on refocus', (
    tester,
  ) async {
    final queries = <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              queries.add(query);
              return const ['Apple', 'Banana'];
            },
            debounceDuration: Duration.zero,
            loadOnFocus: true,
          ),
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(queries, ['']);

    await tester.tapAt(const Offset(380, 60));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(queries, ['']);
  });

  testWidgets(
    'async single with an initial value still loads on focus using an empty query',
    (tester) async {
      final queries = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.async(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              searchOnEmptyQuery: false,
            ),
            value: 'Banana',
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'City'),
          ),
        ),
      );

      expect(find.text('Banana'), findsOneWidget);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Apple'), findsOneWidget);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'loadOnFocus with reloadOnQueryChange false loads once even if input changes before response',
    (tester) async {
      final queries = <String>[];
      final completer = Completer<List<String>>();

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return completer.future;
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
            ),
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(queries, ['']);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'ap');
      await tester.pump();
      expect(queries, ['']);

      completer.complete(const ['Apple', 'Banana']);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(380, 60));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Apple'), findsOneWidget);
    },
  );

  testWidgets(
    'async multiple with loadOnlyOnce does not reload on refocus after selection',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana', 'Cherry'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
              loadOnlyOnce: true,
              searchOnEmptyQuery: false,
            ),
            onChanged: (values) => selected = values,
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tapAt(const Offset(380, 60));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'async multiple does not reload when selecting and unselecting via popup',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana', 'Cherry'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
              searchOnEmptyQuery: false,
            ),
            values: selected,
            onChanged: (values) => selected = values,
            getOptionLabel: (option) => option,
            selectionConfig: const AutocompleteSelectionConfig(
              keepSelectedOptionsVisible: true,
            ),
            behaviorConfig: const AutocompleteBehaviorConfig(
              toggleSelectionOnTap: true,
              closeOnSelect: false,
              clearInputOnSelect: true,
            ),
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      await tester.pumpAndSettle();
      expect(selected, ['Apple']);
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(queries, ['']);
    },
  );

  testWidgets(
    'async multiple does not reload when unselecting by deleting a chip',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana', 'Cherry'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
              searchOnEmptyQuery: false,
            ),
            values: selected,
            onChanged: (values) => selected = values,
            getOptionLabel: (option) => option,
            behaviorConfig: const AutocompleteBehaviorConfig(
              clearInputOnSelect: true,
            ),
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      await tester.pumpAndSettle();
      expect(selected, ['Apple']);
      expect(queries, ['']);

      final chipFinder = find.widgetWithText(InputChip, 'Apple');
      expect(chipFinder, findsOneWidget);
      final chip = tester.widget<InputChip>(chipFinder);
      expect(chip.onDeleted, isNotNull);
      chip.onDeleted!.call();
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(queries, ['']);
    },
  );

  testWidgets(
    'async multiple combobox flow does not reload after select blur and refocus',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 320,
                    child: AutocompleteField<String>.asyncMultiple(
                      asyncConfig: AutocompleteAsyncConfig(
                        optionsBuilder: (query) async {
                          queries.add(query);
                          return const ['Apple', 'Banana', 'Cherry'];
                        },
                        debounceDuration: Duration.zero,
                        loadOnFocus: true,
                        reloadOnQueryChange: false,
                        loadOnlyOnce: true,
                        searchOnEmptyQuery: false,
                      ),
                      values: selected,
                      onChanged: (values) => setState(() => selected = values),
                      getOptionLabel: (option) => option,
                      behaviorConfig: const AutocompleteBehaviorConfig(
                        blurOnSelect: true,
                        clearInputOnSelect: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Fruits'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'loadOnlyOnce persists across widget recreation with external focus node',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];
      var version = 0;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 320,
                    child: AutocompleteField<String>.asyncMultiple(
                      key: ValueKey<int>(version),
                      focusNode: focusNode,
                      asyncConfig: AutocompleteAsyncConfig(
                        optionsBuilder: (query) async {
                          queries.add(query);
                          return const ['Apple', 'Banana', 'Cherry'];
                        },
                        debounceDuration: Duration.zero,
                        loadOnFocus: true,
                        reloadOnQueryChange: false,
                        loadOnlyOnce: true,
                      ),
                      values: selected,
                      onChanged: (values) => setState(() {
                        selected = values;
                        version += 1;
                      }),
                      getOptionLabel: (option) => option,
                      behaviorConfig: const AutocompleteBehaviorConfig(
                        blurOnSelect: true,
                        clearInputOnSelect: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Fruits'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'loadOnlyOnce persists across widget recreation with external controller',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];
      var version = 0;
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 320,
                    child: AutocompleteField<String>.asyncMultiple(
                      key: ValueKey<int>(version),
                      controller: controller,
                      asyncConfig: AutocompleteAsyncConfig(
                        optionsBuilder: (query) async {
                          queries.add(query);
                          return const ['Apple', 'Banana', 'Cherry'];
                        },
                        debounceDuration: Duration.zero,
                        loadOnFocus: true,
                        reloadOnQueryChange: false,
                        loadOnlyOnce: true,
                      ),
                      values: selected,
                      onChanged: (values) => setState(() {
                        selected = values;
                        version += 1;
                      }),
                      getOptionLabel: (option) => option,
                      behaviorConfig: const AutocompleteBehaviorConfig(
                        blurOnSelect: true,
                        clearInputOnSelect: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Fruits'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'loadOnlyOnce persists across widget recreation without external objects',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];
      var version = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 320,
                    child: AutocompleteField<String>.asyncMultiple(
                      key: ValueKey<int>(version),
                      asyncConfig: AutocompleteAsyncConfig(
                        optionsBuilder: (query) async {
                          queries.add(query);
                          return const ['Apple', 'Banana', 'Cherry'];
                        },
                        debounceDuration: Duration.zero,
                        loadOnFocus: true,
                        reloadOnQueryChange: false,
                        loadOnlyOnce: true,
                      ),
                      values: selected,
                      onChanged: (values) => setState(() {
                        selected = values;
                        version += 1;
                      }),
                      getOptionLabel: (option) => option,
                      behaviorConfig: const AutocompleteBehaviorConfig(
                        blurOnSelect: true,
                        clearInputOnSelect: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Fruits'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'async multiple does not reload on refocus after selecting an item',
    (tester) async {
      final queries = <String>[];
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana', 'Cherry'];
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
      expect(queries, ['']);

      await selectPopupOption(tester, 'Apple');
      expect(selected, ['Apple']);

      await tester.tapAt(const Offset(380, 60));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
    },
  );

  testWidgets(
    'async can load once and then filter locally without reloading',
    (tester) async {
      final queries = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.async(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Hello', 'World'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
            ),
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Greeting'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Hello'), findsOneWidget);
      expect(findPopupText('World'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'o');
      await tester.pumpAndSettle();
      expect(queries, ['']);
      expect(findPopupText('Hello'), findsOneWidget);
      expect(findPopupText('World'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'wor');
      await tester.pumpAndSettle();
      expect(queries, ['']);
      expect(findPopupText('Hello'), findsNothing);
      expect(findPopupText('World'), findsOneWidget);
    },
  );

  testWidgets(
    'loadOnlyOnce executes a single remote request even with reloadOnQueryChange enabled',
    (tester) async {
      final queries = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Alpha', 'Beta', 'Gamma'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: true,
              loadOnlyOnce: true,
            ),
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Items'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'al');
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(380, 60));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(queries, ['']);
      expect(findPopupText('Alpha'), findsOneWidget);
    },
  );

  testWidgets('async pagination appends options when scrolling near list end',
      (tester) async {
    var nonPagedCalls = 0;
    final requestedPages = <int>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              nonPagedCalls += 1;
              return const [];
            },
            debounceDuration: Duration.zero,
            loadOnFocus: true,
            paginationConfig: AutocompleteAsyncPaginationConfig<String>(
              pageSize: 4,
              optionsPageBuilder: (query, page, pageSize) async {
                requestedPages.add(page);
                await Future<void>.delayed(const Duration(milliseconds: 20));
                if (page == 1) {
                  return const ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
                }
                if (page == 2) {
                  return const ['Item 5', 'Item 6'];
                }
                return const <String>[];
              },
            ),
          ),
          getOptionLabel: (option) => option,
          popupConfig: const AutocompletePopupConfig(maxHeight: 96),
          decoration: const InputDecoration(labelText: 'Items'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(nonPagedCalls, 0);
    expect(requestedPages, [1]);
    expect(findPopupText('Item 1'), findsOneWidget);
    expect(findPopupText('Item 5'), findsNothing);

    final popupScrollView = find.descendant(
      of: findPopupSurface(),
      matching: find.byType(CustomScrollView),
    );
    await tester.drag(popupScrollView, const Offset(0, -500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pumpAndSettle();

    expect(requestedPages, [1, 2]);
  });

  testWidgets('async popup shows loader while waiting without empty flash', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 60));
              return ['Apple', 'Banana'];
            },
            debounceDuration: const Duration(milliseconds: 120),
            minQueryLength: 1,
          ),
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();

    expect(findPopupSurface(), findsNothing);
    await tester.pump(const Duration(milliseconds: 121));

    expect(findPopupSurface(), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(findPopupText('No options'), findsNothing);

    await tester.pumpAndSettle();
    expect(findPopupText('Apple'), findsOneWidget);
  });

  testWidgets('async requests are debounced while typing', (tester) async {
    final queries = <String>[];

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.async(
          asyncConfig: AutocompleteAsyncConfig(
            optionsBuilder: (query) async {
              queries.add(query);
              return ['Apple', 'Banana']
                  .where((option) => option.toLowerCase().contains(query))
                  .toList(growable: false);
            },
            debounceDuration: const Duration(milliseconds: 150),
            minQueryLength: 1,
          ),
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(const Duration(milliseconds: 50));
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pump(const Duration(milliseconds: 50));
    await tester.enterText(find.byType(TextField), 'app');
    await tester.pump(const Duration(milliseconds: 100));

    expect(queries, isEmpty);

    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpAndSettle();

    expect(queries, ['app']);
    expect(findPopupText('Apple'), findsOneWidget);
  });

  testWidgets(
    'async with loadOnFocus does not reload when only spaces are typed and reloadOnQueryChange is false',
    (tester) async {
      final queries = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana'];
              },
              debounceDuration: Duration.zero,
              loadOnFocus: true,
              reloadOnQueryChange: false,
              searchOnEmptyQuery: false,
            ),
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(queries, ['']);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pumpAndSettle();

      expect(queries, ['']);
    },
  );

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

  testWidgets(
    'async multiple shows custom empty builder before min query length',
    (tester) async {
      final queries = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.asyncMultiple(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async {
                queries.add(query);
                return const ['Apple', 'Banana'];
              },
              debounceDuration: Duration.zero,
              minQueryLength: 2,
              loadOnFocus: false,
            ),
            getOptionLabel: (option) => option,
            renderingConfig: const AutocompleteRenderingConfig<String>(
              emptyBuilder: _typeToSearchEmptyBuilder,
            ),
            decoration: const InputDecoration(labelText: 'Fruits'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);
      expect(findPopupText('Type to find something'), findsOneWidget);
      expect(queries, isEmpty);
    },
  );

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

  testWidgets('single form reset clears selected value and input text', (
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
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');
    expect(find.text('Banana'), findsOneWidget);

    formKey.currentState!.reset();
    await tester.pumpAndSettle();

    expect(find.text('Banana'), findsNothing);
  });

  testWidgets('single onSaved receives selected value in async mode', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    String? savedValue;

    await tester.pumpWidget(
      buildTestApp(
        Form(
          key: formKey,
          child: AutocompleteField<String>.async(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async => const ['Apple', 'Banana'],
              debounceDuration: Duration.zero,
              loadOnFocus: true,
            ),
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

  testWidgets('async single form reset clears selected value and input text', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      buildTestApp(
        Form(
          key: formKey,
          child: AutocompleteField<String>.async(
            asyncConfig: AutocompleteAsyncConfig(
              optionsBuilder: (query) async => const ['Apple', 'Banana'],
              debounceDuration: Duration.zero,
              loadOnFocus: true,
            ),
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');
    expect(find.text('Banana'), findsOneWidget);

    formKey.currentState!.reset();
    await tester.pumpAndSettle();

    expect(find.text('Banana'), findsNothing);
  });
}

class _City {
  const _City(this.id, this.name);

  final String id;
  final String name;
}

Widget _typeToSearchEmptyBuilder(BuildContext context, String query) {
  return const Center(child: Text('Type to find something'));
}

Text _popupOptionLabelText(WidgetTester tester, String label) {
  final tile = find.byKey(ValueKey<String>('autocomplete-option-$label'));
  final labelTextFinder =
      find.descendant(of: tile, matching: find.byType(Text)).first;
  return tester.widget<Text>(labelTextFinder);
}

int _countHighlightedSegments(Text text, Color color) {
  final span = text.textSpan;
  if (span == null) {
    return 0;
  }
  return _countHighlightedSegmentsInSpan(span, color);
}

int _countHighlightedSegmentsInSpan(InlineSpan span, Color color) {
  if (span is! TextSpan) {
    return 0;
  }

  var count = 0;
  if ((span.text?.isNotEmpty ?? false) && span.style?.color == color) {
    count += 1;
  }
  for (final child in span.children ?? const <InlineSpan>[]) {
    count += _countHighlightedSegmentsInSpan(child, color);
  }
  return count;
}
