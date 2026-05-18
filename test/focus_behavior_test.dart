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

  testWidgets('popup scrollbar has no vertical padding', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: List<String>.generate(24, (index) => 'Option $index'),
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final scrollbar = tester.widget<RawScrollbar>(
      find.descendant(
        of: findPopupSurface(),
        matching: find.byType(RawScrollbar),
      ),
    );

    expect(scrollbar.padding, EdgeInsets.zero);
  });

  testWidgets('popup height animation uses configured duration',
      (tester) async {
    const animationDuration = Duration(milliseconds: 320);

    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana', 'Cherry'],
          getOptionLabel: (option) => option,
          popupConfig: const AutocompletePopupConfig(
            heightAnimationDuration: animationDuration,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final animatedSize = tester.widget<AnimatedSize>(
      find.descendant(
        of: findPopupSurface(),
        matching: find.byType(AnimatedSize),
      ),
    );
    expect(animatedSize.duration, animationDuration);
  });

  testWidgets('popup supports disabling height animation', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana', 'Cherry'],
          getOptionLabel: (option) => option,
          popupConfig: const AutocompletePopupConfig(
            heightAnimationDuration: Duration.zero,
          ),
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(findPopupSurface(), findsOneWidget);
    expect(findPopupText('Apple'), findsOneWidget);
    expect(
      find.descendant(
        of: findPopupSurface(),
        matching: find.byType(AnimatedSize),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'popup scrolling works when chip area has maxInputAreaHeight',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.multiple(
            options: List<String>.generate(30, (index) => 'Option $index'),
            values: const [
              'Option 0',
              'Option 1',
              'Option 2',
              'Option 3',
              'Option 4',
              'Option 5',
              'Option 6',
              'Option 7',
            ],
            getOptionLabel: (option) => option,
            chipConfig: const AutocompleteChipConfig<String>(
              maxInputAreaHeight: 90,
            ),
            behaviorConfig: const AutocompleteBehaviorConfig(
              closeOnSelect: false,
              clearInputOnSelect: true,
            ),
            decoration: const InputDecoration(labelText: 'Tags'),
          ),
          width: 240,
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('autocomplete-dropdown-button')),
      );
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);
      final popupScrollView = find.descendant(
        of: findPopupSurface(),
        matching: find.byType(CustomScrollView),
      );
      expect(popupScrollView, findsOneWidget);

      await tester.drag(popupScrollView, const Offset(0, -120));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty popup is shown when there are no matching options', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        AutocompleteField<String>.single(
          options: const ['Apple', 'Banana'],
          getOptionLabel: (option) => option,
          decoration: const InputDecoration(labelText: 'Fruit'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    expect(findPopupSurface(), findsOneWidget);
    expect(findPopupText('No options'), findsOneWidget);
  });

  testWidgets(
    'popup stays within viewport when space is limited above and below',
    (tester) async {
      tester.view.physicalSize = const Size(320, 220);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 88),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AutocompleteField<String>.single(
                    options: List<String>.generate(
                      24,
                      (index) => 'Option $index',
                    ),
                    getOptionLabel: (option) => option,
                    popupConfig: const AutocompletePopupConfig(maxHeight: 180),
                    decoration: const InputDecoration(labelText: 'Fruit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      final popupTop = tester.getTopLeft(findPopupSurface()).dy;
      final popupBottom = tester.getBottomLeft(findPopupSurface()).dy;
      final viewportHeight = tester.getSize(find.byType(Scaffold)).height;

      expect(popupTop, greaterThanOrEqualTo(0));
      expect(popupBottom, lessThanOrEqualTo(viewportHeight));
    },
  );

  testWidgets('popup above placement stays visually attached to the field', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 360);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AutocompleteField<String>.single(
                  options: const ['Apple', 'Banana'],
                  getOptionLabel: (option) => option,
                  popupConfig: const AutocompletePopupConfig(
                    maxHeight: 220,
                    offset: Offset(0, 8),
                  ),
                  decoration: const InputDecoration(labelText: 'Fruit'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final popupBottom = tester.getBottomLeft(findPopupSurface()).dy;
    final fieldTop = tester.getTopLeft(find.byType(TextField)).dy;
    final gap = (fieldTop - popupBottom).abs();

    expect(gap, lessThanOrEqualTo(10));
  });
}
