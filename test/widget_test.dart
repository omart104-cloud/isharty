import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/app/app.dart';
import 'package:isharty/core/di/service_locator.dart';

void main() {
  setUp(() {
    ServiceLocator.instance.init();
  });

  testWidgets('Isharaty Maak smoke test and tab switching', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const IsharatyApp());
    await tester.pumpAndSettle();

    // 1. Verify Home screen elements
    expect(find.text('إشارتي معاك'), findsWidgets);
    expect(find.text('خلّي التواصل أسهل ✨'), findsOneWidget);
    expect(find.text('الوصول السريع'), findsOneWidget);
    expect(find.text('إشارات هتحتاجها كتير'), findsOneWidget);

    // 2. Switch to Dictionary tab
    await tester.tap(find.text('القاموس').first);
    await tester.pumpAndSettle();
    expect(find.text('قاموس الإشارات'), findsWidgets);
    expect(find.text('التحيات'), findsWidgets);

    // 3. Switch to Sentence Builder tab
    await tester.tap(find.text('اكتب جملة').first);
    await tester.pumpAndSettle();
    expect(find.text('تركيب جملة بلغة الإشارة'), findsOneWidget);
    expect(find.text('بنك الكلمات المعتمدة للإضافة'), findsOneWidget);

    // 4. Switch to Situations tab
    await tester.tap(find.text('المواقف'));
    await tester.pumpAndSettle();
    expect(find.text('مواقف المدرسة'), findsWidgets);
    expect(find.text('داخل الفصل الدراسي'), findsOneWidget);

    // 5. Switch to Profile tab
    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    expect(find.text('حسابي والإعدادات'), findsOneWidget);
    expect(find.text('أحمد مصطفى'), findsOneWidget);
  });

  testWidgets('Dictionary search and favorites test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const IsharatyApp());
    await tester.pumpAndSettle();

    // Switch to dictionary
    await tester.tap(find.text('القاموس').first);
    await tester.pumpAndSettle();

    // Enter search query
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);
    await tester.enterText(searchInput, 'شكرًا');
    await tester.pumpAndSettle();

    // Verify search filtered results
    expect(find.text('شكرًا'), findsWidgets);
  });

  testWidgets('Sentence Builder chip deletion and bounds safety test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const IsharatyApp());
    await tester.pumpAndSettle();

    // Switch to Sentence Builder tab
    await tester.tap(find.text('اكتب جملة').first);
    await tester.pumpAndSettle();

    // Tap "الإشارة التالية" twice to move _activeStepIndex to 2
    final nextButton = find.text('الإشارة التالية');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Delete chips using their close icon
    final deleteIcons = find.byIcon(Icons.close_rounded);
    expect(deleteIcons, findsWidgets);

    // Delete the first chip, sentence shrinks
    await tester.tap(deleteIcons.first);
    await tester.pumpAndSettle();

    // Delete another chip
    final remainingDeleteIcons = find.byIcon(Icons.close_rounded);
    if (remainingDeleteIcons.evaluate().isNotEmpty) {
      await tester.tap(remainingDeleteIcons.first);
      await tester.pumpAndSettle();
    }

    // No exception thrown!
    expect(find.byType(IsharatyApp), findsOneWidget);
  });
}
