import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void configureTestView(
  WidgetTester tester, {
  Size size = const Size(320, 640),
  double devicePixelRatio = 1.0,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = devicePixelRatio;
  addTearDown(tester.view.reset);
}

Future<void> pumpKeyboardInset(WidgetTester tester, double bottom) async {
  tester.view.viewInsets = FakeViewPadding(bottom: bottom);
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

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

  testWidgets(
    'tapping a focused single field reopens the popup after selection',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.single(
            options: const ['Apple', 'Banana'],
            focusNode: focusNode,
            getOptionLabel: (option) => option,
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await selectPopupOption(tester, 'Banana');

      expect(focusNode.hasFocus, isTrue);
      expect(findPopupSurface(), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);
      expect(findPopupText('Apple'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping a focused multiple field reopens the popup after selection',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.multiple(
            options: const ['Apple', 'Banana'],
            focusNode: focusNode,
            getOptionLabel: (option) => option,
            behaviorConfig: const AutocompleteBehaviorConfig(
              closeOnSelect: true,
              clearInputOnSelect: true,
            ),
            decoration: const InputDecoration(labelText: 'Fruit'),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await selectPopupOption(tester, 'Banana');

      expect(focusNode.hasFocus, isTrue);
      expect(findPopupSurface(), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);
      expect(findPopupText('Apple'), findsOneWidget);
    },
  );

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

  testWidgets(
    'popup stays open through keyboard metric changes and dismissal',
    (tester) async {
      configureTestView(tester, size: const Size(320, 640));
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildTestApp(
          AutocompleteField<String>.single(
            options: const ['Apple', 'Banana', 'Cherry'],
            focusNode: focusNode,
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

      for (final inset in <double>[80, 160, 240]) {
        await pumpKeyboardInset(tester, inset);
        expect(findPopupSurface(), findsOneWidget);
        expect(findPopupText('Apple'), findsOneWidget);
        expect(focusNode.hasFocus, isTrue);
      }

      await pumpKeyboardInset(tester, 0);

      expect(findPopupSurface(), findsOneWidget);
      expect(findPopupText('Apple'), findsOneWidget);
      expect(focusNode.hasFocus, isTrue);
    },
  );

  testWidgets('popup repositions above when keyboard removes space below', (
    tester,
  ) async {
    configureTestView(tester, size: const Size(320, 640));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 320),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AutocompleteField<String>.single(
                  options: const ['Apple', 'Banana', 'Cherry'],
                  getOptionLabel: (option) => option,
                  popupConfig: const AutocompletePopupConfig(
                    maxHeight: 180,
                    heightAnimationDuration: Duration.zero,
                  ),
                  decoration: const InputDecoration(labelText: 'Fruit'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final fieldRectBefore = tester.getRect(find.byType(TextField));
    final popupRectBefore = tester.getRect(findPopupSurface());
    expect(popupRectBefore.top, greaterThanOrEqualTo(fieldRectBefore.bottom));

    await pumpKeyboardInset(tester, 260);

    final fieldRectAfter = tester.getRect(find.byType(TextField));
    final popupRectAfter = tester.getRect(findPopupSurface());

    expect(findPopupSurface(), findsOneWidget);
    expect(popupRectAfter.bottom, lessThanOrEqualTo(fieldRectAfter.top + 1));
  });

  testWidgets('popup remains below when keyboard still leaves space below', (
    tester,
  ) async {
    configureTestView(tester, size: const Size(320, 640));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AutocompleteField<String>.single(
                  options: const ['Apple', 'Banana', 'Cherry'],
                  getOptionLabel: (option) => option,
                  popupConfig: const AutocompletePopupConfig(
                    maxHeight: 180,
                    heightAnimationDuration: Duration.zero,
                  ),
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
    await pumpKeyboardInset(tester, 120);

    final fieldRect = tester.getRect(find.byType(TextField));
    final popupRect = tester.getRect(findPopupSurface());

    expect(findPopupSurface(), findsOneWidget);
    expect(popupRect.top, greaterThanOrEqualTo(fieldRect.bottom - 1));
  });

  testWidgets('popup stays attached while the field moves in a scroll view', (
    tester,
  ) async {
    configureTestView(tester, size: const Size(320, 640));
    final focusNode = FocusNode();
    final scrollController = ScrollController();
    addTearDown(focusNode.dispose);
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 220),
                  AutocompleteField<String>.single(
                    options: const ['Apple', 'Banana', 'Cherry'],
                    focusNode: focusNode,
                    getOptionLabel: (option) => option,
                    popupConfig: const AutocompletePopupConfig(
                      heightAnimationDuration: Duration.zero,
                    ),
                    decoration: const InputDecoration(labelText: 'Fruit'),
                  ),
                  const SizedBox(height: 800),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final fieldRectBefore = tester.getRect(find.byType(TextField));
    final popupRectBefore = tester.getRect(findPopupSurface());
    final initialGap = popupRectBefore.top - fieldRectBefore.bottom;

    scrollController.jumpTo(120);
    await tester.pump();
    await tester.pump();

    final fieldRectAfter = tester.getRect(find.byType(TextField));
    final popupRectAfter = tester.getRect(findPopupSurface());
    final updatedGap = popupRectAfter.top - fieldRectAfter.bottom;

    expect(findPopupSurface(), findsOneWidget);
    expect(focusNode.hasFocus, isTrue);
    expect((updatedGap - initialGap).abs(), lessThanOrEqualTo(1));
  });

  testWidgets(
    'popup scroll does not dismiss focus inside onDrag parent scroll views',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    AutocompleteField<String>.single(
                      options: List<String>.generate(
                        24,
                        (index) => 'Option $index',
                      ),
                      focusNode: focusNode,
                      getOptionLabel: (option) => option,
                      popupConfig: const AutocompletePopupConfig(
                        maxHeight: 160,
                        heightAnimationDuration: Duration.zero,
                      ),
                      decoration: const InputDecoration(labelText: 'Fruit'),
                    ),
                    const SizedBox(height: 800),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);

      final popupScrollable = find.descendant(
        of: findPopupSurface(),
        matching: find.byType(Scrollable),
      );
      final scrollableState = tester.state<ScrollableState>(popupScrollable);
      expect(scrollableState.position.pixels, 0);

      await tester.drag(findPopupSurface(), const Offset(0, -240));
      await tester.pumpAndSettle();

      expect(findPopupSurface(), findsOneWidget);
      expect(focusNode.hasFocus, isTrue);
      expect(scrollableState.position.pixels, greaterThan(0));
    },
  );
}
