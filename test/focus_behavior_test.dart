import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('tapping outside closes the popup', (tester) async {
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
    expect(findPopupText('Apple'), findsOneWidget);

    await tester.tapAt(const Offset(380, 60));
    await tester.pumpAndSettle();

    expect(findPopupText('Apple'), findsNothing);
  });

  testWidgets('blurOnSelect removes focus after selection', (tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          focusNode: focusNode,
          getOptionLabel: (option) => option,
          behaviorConfig: const AutocompleteBehaviorConfig(blurOnSelect: true),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await selectPopupOption(tester, 'Banana');

    expect(focusNode.hasFocus, isFalse);
    focusNode.dispose();
  });

  testWidgets('clearOnBlur removes the active query', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          behaviorConfig: const AutocompleteBehaviorConfig(clearOnBlur: true),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'App');
    await tester.pumpAndSettle();
    expect(find.text('App'), findsOneWidget);

    await tester.tapAt(const Offset(380, 60));
    await tester.pumpAndSettle();

    expect(find.text('App'), findsNothing);
  });

  testWidgets('popup sizes to its content instead of filling the screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana', 'Cherry'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final popupSize = tester.getSize(findPopupSurface());
    final screenHeight = tester.getSize(find.byType(Scaffold)).height;

    expect(popupSize.height, lessThan(220));
    expect(popupSize.height, lessThan(screenHeight));
  });
}
