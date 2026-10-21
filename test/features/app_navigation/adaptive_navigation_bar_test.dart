import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/app/app.dart';
import 'package:isharty/core/di/service_locator.dart';
import 'package:isharty/core/widgets/adaptive_back_button.dart';
import 'package:isharty/core/widgets/app_adaptive_navigation_bar.dart';

void main() {
  setUp(() {
    ServiceLocator.instance.init();
  });

  group('Adaptive Navigation Bar & Performance Tests', () {
    testWidgets('AppAdaptiveNavigationBar has all 5 destinations with proper labels', (tester) async {
      expect(AppAdaptiveNavigationBar.destinations.length, 5);
      final labels = AppAdaptiveNavigationBar.destinations.map((e) => e.label).toList();
      expect(labels, ['الرئيسية', 'القاموس', 'اكتب جملة', 'المواقف', 'حسابي']);
    });

    testWidgets('Tab switching does NOT cause full MaterialApp rebuild (Performance Benchmark)', (tester) async {
      tester.view.physicalSize = const Size(600, 1100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      int materialAppBuildCount = 0;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            materialAppBuildCount++;
            return const IsharatyApp();
          },
        ),
      );
      await tester.pumpAndSettle();

      final initialBuildCount = materialAppBuildCount;

      // Tap through all 5 tabs rapidly
      await tester.tap(find.text('القاموس').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('اكتب جملة').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('المواقف'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('حسابي'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('الرئيسية').first);
      await tester.pumpAndSettle();

      // Verify outer root build count remained stable (no root rebuild thrashing)
      expect(materialAppBuildCount, equals(initialBuildCount),
          reason: 'Switching tabs must not trigger expensive root rebuilds');
    });

    testWidgets('AppAdaptiveScaffold renders on iOS platform with Liquid Glass bar', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        tester.view.physicalSize = const Size(600, 1100);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          Theme(
            data: ThemeData(platform: TargetPlatform.iOS),
            child: const IsharatyApp(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppAdaptiveScaffold), findsOneWidget);
        expect(find.text('الرئيسية'), findsWidgets);
        expect(find.text('القاموس'), findsWidgets);

        await tester.tap(find.text('القاموس').first);
        await tester.pumpAndSettle();
        expect(find.text('قاموس الإشارات'), findsWidgets);
      } finally {
        debugDefaultTargetPlatformOverride = null;
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      }
    });

    testWidgets('AppAdaptiveBackButton renders iOS chevron on iOS and pops route', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        bool popped = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              appBar: AppBar(
                leading: AppAdaptiveBackButton(
                  onPressed: () => popped = true,
                ),
              ),
              body: const Center(child: Text('iOS Page')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);

        await tester.tap(find.byType(AppAdaptiveBackButton));
        await tester.pumpAndSettle();
        expect(popped, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('AppAdaptiveBackButton renders Material arrow on Android and pops route', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      try {
        bool popped = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              appBar: AppBar(
                leading: AppAdaptiveBackButton(
                  onPressed: () => popped = true,
                ),
              ),
              body: const Center(child: Text('Android Page')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

        await tester.tap(find.byType(AppAdaptiveBackButton));
        await tester.pumpAndSettle();
        expect(popped, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
