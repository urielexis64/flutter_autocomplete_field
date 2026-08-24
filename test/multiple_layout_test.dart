import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('multiple field focuses when the chip area is tapped', (
    tester,
  ) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          values: const ['Apple'],
          focusNode: focusNode,
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.text('Apple'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(focusNode.hasFocus, isTrue);
    focusNode.dispose();
  });

  testWidgets('multiple field grows vertically without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          values: const ['Alpha', 'Beta', 'Gamma'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(
            labelText: 'Tags',
            border: OutlineInputBorder(),
          ),
        ),
        width: 180,
      ),
    );

    final size = tester.getSize(
      find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator && widget.decoration.labelText == 'Tags',
      ),
    );
    expect(size.height, greaterThan(56));
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrap chip layout is used by default', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          values: const ['Alpha', 'Beta', 'Gamma'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Tags'),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('autocomplete-chip-layout-wrap')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('autocomplete-chip-layout-horizontal')),
      findsNothing,
    );
  });

  testWidgets('horizontal chip layout can be enabled by config',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          values: const ['Alpha', 'Beta', 'Gamma'],
          getOptionLabel: (option) => option,
          chipConfig: const AutocompleteChipConfig<String>(
            layoutMode: AutocompleteChipLayoutMode.horizontalScroll,
          ),
          decoration: const InputDecoration(labelText: 'Tags'),
        ),
      ),
    );

    final horizontal = tester.widget<SingleChildScrollView>(
      find.byKey(const ValueKey<String>('autocomplete-chip-layout-horizontal')),
    );
    expect(horizontal.scrollDirection, Axis.horizontal);
    expect(
      find.byKey(const ValueKey<String>('autocomplete-chip-layout-wrap')),
      findsNothing,
    );
  });

  testWidgets('limitTags remains applied while focused by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          values: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          getOptionLabel: (option) => option,
          chipConfig: const AutocompleteChipConfig<String>(limitTags: 2),
          decoration: const InputDecoration(labelText: 'Tags'),
        ),
        width: 220,
      ),
    );

    final field = find.byWidgetPredicate(
      (widget) =>
          widget is InputDecorator && widget.decoration.labelText == 'Tags',
    );
    expect(
        find.descendant(of: field, matching: find.text('+2')), findsOneWidget);
    expect(
        find.descendant(of: field, matching: find.text('Gamma')), findsNothing);
    expect(
        find.descendant(of: field, matching: find.text('Delta')), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(
        find.descendant(of: field, matching: find.text('+2')), findsOneWidget);
    expect(
        find.descendant(of: field, matching: find.text('Gamma')), findsNothing);
    expect(
        find.descendant(of: field, matching: find.text('Delta')), findsNothing);
  });

  testWidgets(
    'tapping the hidden-count chip expands hidden chips without focusing',
    (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.multiple(
            options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
            values: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
            focusNode: focusNode,
            getOptionLabel: (option) => option,
            chipConfig: const AutocompleteChipConfig<String>(limitTags: 2),
            decoration: const InputDecoration(labelText: 'Tags'),
          ),
          width: 220,
        ),
      );

      final field = find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator && widget.decoration.labelText == 'Tags',
      );
      expect(
        find.descendant(of: field, matching: find.text('+2')),
        findsOneWidget,
      );
      expect(focusNode.hasFocus, isFalse);

      await tester.tap(
        find.byKey(const ValueKey<String>('autocomplete-hidden-count-chip')),
      );
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
      expect(findPopupSurface(), findsNothing);
      expect(
        find.descendant(of: field, matching: find.text('+2')),
        findsNothing,
      );
      expect(
        find.descendant(of: field, matching: find.text('Gamma')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: field, matching: find.text('Delta')),
        findsOneWidget,
      );
      focusNode.dispose();
    },
  );

  testWidgets('maxInputAreaHeight caps chip/input area height with scroll', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.multiple(
          options: const [
            'Alpha',
            'Beta',
            'Gamma',
            'Delta',
            'Epsilon',
            'Zeta',
            'Eta',
            'Theta',
          ],
          values: const [
            'Alpha',
            'Beta',
            'Gamma',
            'Delta',
            'Epsilon',
            'Zeta',
            'Eta',
            'Theta',
          ],
          getOptionLabel: (option) => option,
          chipConfig: const AutocompleteChipConfig<String>(
            maxInputAreaHeight: 90,
          ),
          decoration: const InputDecoration(labelText: 'Tags'),
        ),
        width: 180,
      ),
    );

    final scrollArea = find.byKey(
      const ValueKey<String>('autocomplete-chip-scroll-area'),
    );
    expect(scrollArea, findsOneWidget);
    final scrollAreaSize = tester.getSize(scrollArea);
    expect(scrollAreaSize.height, lessThanOrEqualTo(90));
  });

  testWidgets(
    'label floats when focused, when text exists, and when chips exist',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.multiple(
            options: const ['Apple', 'Banana'],
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(
              labelText: 'Fruit',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      );

      final initialY = tester.getTopLeft(find.text('Fruit')).dy;

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      final focusedY = tester.getTopLeft(find.text('Fruit')).dy;

      await tester.enterText(find.byType(TextField), 'App');
      await tester.pumpAndSettle();
      final textY = tester.getTopLeft(find.text('Fruit')).dy;

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.multiple(
            options: const ['Apple', 'Banana'],
            values: const ['Apple'],
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(
              labelText: 'Fruit',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final chipsY = tester.getTopLeft(find.text('Fruit')).dy;

      expect(focusedY, lessThan(initialY));
      expect(textY, lessThan(initialY));
      expect(chipsY, lessThan(initialY));
    },
  );
}
