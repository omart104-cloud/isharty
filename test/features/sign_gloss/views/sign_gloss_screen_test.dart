import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/features/sign_gloss/models/sign_gloss_model.dart';
import 'package:isharty/features/sign_gloss/repository/signbank_repository.dart';
import 'package:isharty/features/sign_gloss/views/sign_gloss_screen.dart';
import 'package:isharty/features/sign_gloss/views/widgets/sign_metadata_card.dart';

class MockSignbankRepository extends SignbankRepository {
  final Future<SignGlossModel> Function(int id) onFetch;

  MockSignbankRepository(this.onFetch);

  @override
  Future<SignGlossModel> fetchGlossById(int id) => onFetch(id);
}

void main() {
  group('SignGlossScreen Widget Tests', () {
    testWidgets('renders search input bar with default ID 1 and Fetch button', (tester) async {
      final repo = MockSignbankRepository((id) async {
        return SignGlossModel(
          id: id,
          glossName: 'SUMMARIZE',
          videoUrl: null,
          keywords: const ['summary'],
        );
      });

      await tester.pumpWidget(
        MaterialApp(
          home: SignGlossScreen(
            initialGlossId: 1,
            repository: repo,
          ),
        ),
      );

      // Verify header and appbar
      expect(find.text('ASL Signbank Gloss'), findsOneWidget);

      // Verify search input has initial value 1
      expect(find.widgetWithText(TextFormField, '1'), findsOneWidget);
      expect(find.text('Fetch Sign'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('displays CircularProgressIndicator when state is loading', (tester) async {
      final completer = Completer<SignGlossModel>();
      final repo = MockSignbankRepository((id) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: SignGlossScreen(
            initialGlossId: 1,
            repository: repo,
          ),
        ),
      );

      // Initial frame with loading
      await tester.pump();

      // Should show progress indicator and loading text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('Fetching Sign Gloss #1'), findsOneWidget);

      // Complete future and settle to cleanly finish test
      completer.complete(const SignGlossModel(id: 1, glossName: 'RESOLVED'));
      await tester.pumpAndSettle();
    });

    testWidgets('displays gloss title, metadata, and keywords when loaded', (tester) async {
      const loadedModel = SignGlossModel(
        id: 1,
        glossName: 'SUMMARIZE',
        videoUrl: null,
        keywords: ['abbreviate', 'concise', 'summary'],
      );

      final repo = MockSignbankRepository((id) async => loadedModel);

      await tester.pumpWidget(
        MaterialApp(
          home: SignGlossScreen(
            initialGlossId: 1,
            repository: repo,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check title appears in Header and Metadata Card (2 widgets)
      expect(find.text('SUMMARIZE'), findsNWidgets(2));
      expect(find.text('ASL Sign Gloss • ID #1'), findsOneWidget);
      expect(find.byType(SignMetadataCard), findsOneWidget);
      expect(find.text('abbreviate'), findsOneWidget);
      expect(find.text('concise'), findsOneWidget);
    });

    testWidgets('displays error card and retry button on fetch failure', (tester) async {
      var callCount = 0;
      final repo = MockSignbankRepository((id) async {
        callCount++;
        throw const SignbankNotFoundException('Sign gloss #999 was not found');
      });

      await tester.pumpWidget(
        MaterialApp(
          home: SignGlossScreen(
            initialGlossId: 999,
            repository: repo,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error UI is displayed
      expect(find.text('Unable to Load Gloss'), findsOneWidget);
      expect(find.text('Sign gloss #999 was not found'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(callCount, 1);

      // Tap Retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(callCount, 2);
    });

    testWidgets('SignMetadataCard displays full metadata and video link', (tester) async {
      const modelWithVideo = SignGlossModel(
        id: 7,
        glossName: 'HELLO',
        videoUrl: 'https://aslsignbank.haskins.yale.edu/media/hello.mp4',
        keywords: ['hi', 'welcome'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignMetadataCard(gloss: modelWithVideo),
          ),
        ),
      );

      expect(find.text('#7'), findsOneWidget);
      expect(find.text('HELLO'), findsOneWidget);
      expect(find.text('Video Available'), findsOneWidget);
      expect(find.text('https://aslsignbank.haskins.yale.edu/media/hello.mp4'), findsOneWidget);
      expect(find.text('hi'), findsOneWidget);
      expect(find.text('welcome'), findsOneWidget);
    });
  });
}
