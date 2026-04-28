import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

Finder findPopupSurface() {
  return find.byKey(const ValueKey<String>('autocomplete-popup-surface'));
}

Finder findPopupText(String text) {
  return find.descendant(of: findPopupSurface(), matching: find.text(text));
}

Finder findPopupOption(String text) {
  return find.byKey(ValueKey<String>('autocomplete-option-$text'));
}

Future<void> selectPopupOption(WidgetTester tester, String text) async {
  final option = tester.widget<InkWell>(findPopupOption(text));
  option.onTap?.call();
  await tester.pumpAndSettle();
}

Finder findCreateOption(String text) {
  return find.byKey(ValueKey<String>('autocomplete-create-option-$text'));
}

Future<void> selectCreateOption(WidgetTester tester, String text) async {
  final option = tester.widget<InkWell>(findCreateOption(text));
  option.onTap?.call();
  await tester.pumpAndSettle();
}
