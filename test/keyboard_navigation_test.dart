import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ArrowDown highlights and Enter selects', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana', 'Cherry'],
          openOnFocus: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(selected, 'Apple');
  });

  testWidgets('Home and End move highlight when enabled', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana', 'Cherry'],
          openOnFocus: true,
          handleHomeEndKeys: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(selected, 'Cherry');
  });

  testWidgets('disableListWrap prevents wrapping from first to last', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          openOnFocus: true,
          disableListWrap: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(selected, 'Apple');
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(24), child: child),
    ),
  );
}
