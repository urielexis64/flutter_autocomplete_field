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
