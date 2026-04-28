import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('multiple selection emits selected values', (tester) async {
    var selected = <String>[];
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          multiple: true,
          openOnFocus: true,
          onValuesChanged: (values) => selected = values,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();

    expect(selected, ['Apple']);
  });

  testWidgets(
    'multiple selection keeps focus and popup when blurOnSelect is false',
    (tester) async {
      var selected = <String>[];
      await tester.pumpWidget(
        _wrap(
          AutocompleteField<String>(
            options: const ['Apple', 'Banana'],
            multiple: true,
            openOnFocus: true,
            blurOnSelect: false,
            onValuesChanged: (values) => selected = values,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(selected, ['Apple']);
      expect(textField.focusNode?.hasFocus, isTrue);
      expect(find.text('Banana'), findsOneWidget);
    },
  );

  testWidgets('Backspace removes last chip when input is empty', (
    tester,
  ) async {
    var selected = <String>['Apple', 'Banana'];
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana'],
          multiple: true,
          defaultValues: const ['Apple', 'Banana'],
          onValuesChanged: (values) => selected = values,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(selected, ['Apple']);
  });

  testWidgets('limitTags hides extra chips while not focused', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Apple', 'Banana', 'Cherry'],
          multiple: true,
          limitTags: 2,
          defaultValues: const ['Apple', 'Banana', 'Cherry'],
        ),
      ),
    );

    expect(find.text('+1'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('+1'), findsNothing);
    expect(find.text('Cherry'), findsOneWidget);
  });

  testWidgets('fixed chips are not removed by Backspace', (tester) async {
    var selected = <String>['Fixed'];
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const ['Fixed', 'Other'],
          multiple: true,
          defaultValues: const ['Fixed'],
          getSelectedItemDisabled: (value) => value == 'Fixed',
          onValuesChanged: (values) => selected = values,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(selected, ['Fixed']);
    expect(find.text('Fixed'), findsOneWidget);
  });

  testWidgets('chips do not cover the clear button', (tester) async {
    var selected = <String>['A very long selected value', 'Another long value'];
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 280,
          child: AutocompleteField<String>.multiple(
            options: const ['A very long selected value', 'Another long value'],
            defaultValues: selected,
            chipLabelMaxWidth: 72,
            onValuesChanged: (values) => selected = values,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Clear'));
    await tester.pumpAndSettle();

    expect(selected, isEmpty);
  });

  testWidgets('tapping chip area focuses the text field', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>.multiple(
          options: const ['Apple', 'Banana'],
          defaultValues: const ['Apple'],
        ),
      ),
    );

    await tester.tap(find.text('Apple'), warnIfMissed: false);
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.focusNode?.hasFocus, isTrue);
  });

  testWidgets('chipBuilder customizes selected chips', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>.multiple(
          options: const ['Apple'],
          defaultValues: const ['Apple'],
          chipBuilder: (context, value, state) => ActionChip(
            label: Text('selected-$value'),
            onPressed: state.onRemove,
          ),
        ),
      ),
    );

    expect(find.text('selected-Apple'), findsOneWidget);
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(24), child: child),
    ),
  );
}
