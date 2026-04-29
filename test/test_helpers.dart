import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in a predictable Material test scaffold.
///
/// Includes an explicit outside tap region used by focus/overlay tests.
Widget buildTestApp(Widget child, {double width = 320}) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: width, child: child),
            const Expanded(
              child: ColoredBox(
                key: Key('outside-area'),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Finds the autocomplete popup surface in the widget tree.
Finder findPopupSurface() {
  return find.byKey(const ValueKey<String>('autocomplete-popup-surface'));
}

/// Finds [text] inside the popup surface only.
Finder findPopupText(String text) {
  return find.descendant(of: findPopupSurface(), matching: find.text(text));
}

/// Finds an option tile by its generated option key.
Finder findPopupOption(String text) {
  return find.byKey(ValueKey<String>('autocomplete-option-$text'));
}

/// Taps a popup option and waits for resulting UI updates.
Future<void> selectPopupOption(WidgetTester tester, String text) async {
  final option = tester.widget<InkWell>(findPopupOption(text));
  option.onTap?.call();
  await tester.pumpAndSettle();
}

/// Finds the creatable synthetic option row by generated key.
Finder findCreateOption(String text) {
  return find.byKey(ValueKey<String>('autocomplete-create-option-$text'));
}

/// Taps the creatable row and waits for resulting UI updates.
Future<void> selectCreateOption(WidgetTester tester, String text) async {
  final option = tester.widget<InkWell>(findCreateOption(text));
  option.onTap?.call();
  await tester.pumpAndSettle();
}
