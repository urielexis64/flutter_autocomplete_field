import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('focused factory constructors configure expected modes', () {
    final combo = AutocompleteField<String>.comboBox(options: const ['Apple']);
    final multiple = AutocompleteField<String>.multiple(
      options: const ['Apple'],
    );
    final freeSolo = AutocompleteField<String>.freeSolo(
      options: const ['Apple'],
    );
    final asyncField = AutocompleteField<String>.async(
      asyncOptionsBuilder: (query) async => [query],
    );

    expect(combo.multiple, isFalse);
    expect(combo.freeSolo, isFalse);
    expect(multiple.multiple, isTrue);
    expect(multiple.freeSolo, isFalse);
    expect(freeSolo.multiple, isFalse);
    expect(freeSolo.freeSolo, isTrue);
    expect(asyncField.asyncOptionsBuilder, isNotNull);
  });

  testWidgets('openOnFocus opens the popup', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          openOnFocus: true,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('tap selects a single option', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          openOnFocus: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(selected, 'Banana');
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('selecting an option keeps focus when blurOnSelect is false', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>.comboBox(
          options: const ['Apple', 'Banana'],
          openOnFocus: true,
          blurOnSelect: false,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.focusNode?.hasFocus, isTrue);
  });

  testWidgets('selecting an option blurs when blurOnSelect is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>.comboBox(
          options: const ['Apple', 'Banana'],
          openOnFocus: true,
          blurOnSelect: true,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.focusNode?.hasFocus, isFalse);
  });

  testWidgets('clearOnEscape clears value and input', (tester) async {
    String? selected = 'Apple';
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          defaultValue: 'Apple',
          openOnFocus: true,
          clearOnEscape: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('custom option builder receives input value', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Alpha'],
          openOnFocus: true,
          optionBuilder: (context, option, state) =>
              Text('${state.inputValue}:$option'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'al');
    await tester.pumpAndSettle();

    expect(find.text('al:Alpha'), findsOneWidget);
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(24), child: child),
    ),
  );
}
