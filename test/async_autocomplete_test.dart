import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loadOptionsOnOpen shows loading then options', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const [],
          openOnFocus: true,
          loadingText: 'Loading...',
          loadOptionsOnOpen: () async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return ['Apple', 'Banana'];
          },
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('asyncOptionsBuilder searches as input changes', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AutocompleteField<String>(
          options: const [],
          asyncOptionsBuilder: (query) async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return [
              'Apple',
              'Banana',
            ].where((option) => option.toLowerCase().contains(query)).toList();
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'app');
    await tester.pump();
    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 80));
    await tester.pumpAndSettle();

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(24), child: child),
    ),
  );
}
