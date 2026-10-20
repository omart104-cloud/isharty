import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/core/di/service_locator.dart';
import 'package:isharty/features/dictionary/data/sign_model.dart';
import 'package:isharty/features/dictionary/data/signs_data.dart';
import 'package:isharty/features/dictionary/presentation/cubit/dictionary_cubit.dart';
import 'package:isharty/features/dictionary/presentation/sign_detail_sheet.dart';
import 'package:isharty/features/dictionary/presentation/widgets/sign_card.dart';

void main() {
  setUp(() {
    ServiceLocator.instance.init();
  });

  group('Dictionary Model & Video Sync Tests', () {
    test('SignModel holds video metadata and hasVideo returns true', () {
      const sign = SignModel(
        id: 'test_sign',
        arabicWord: 'كتاب',
        category: 'المدرسة',
        description: 'وصف',
        handShape: 'كف',
        movementSteps: ['خطوة 1'],
        usageNote: 'ملاحظة',
        videoUrl: 'https://aslsignbank.com/dictionary/protected_media/glossvideo/ASL/BO/BOOK-418.mp4',
        signbankGlossId: 418,
        glossEnglish: 'BOOK',
      );

      expect(sign.hasVideo, isTrue);
      expect(sign.signbankGlossId, 418);
      expect(sign.glossEnglish, 'BOOK');

      final json = sign.toJson();
      expect(json['videoUrl'], 'https://aslsignbank.com/dictionary/protected_media/glossvideo/ASL/BO/BOOK-418.mp4');
      expect(json['signbankGlossId'], 418);
      expect(json['glossEnglish'], 'BOOK');

      final fromJson = SignModel.fromJson(json);
      expect(fromJson.hasVideo, isTrue);
      expect(fromJson.signbankGlossId, 418);
      expect(fromJson.glossEnglish, 'BOOK');
    });

    test('All 20 signs in SignsData are synchronized with valid video and gloss metadata', () {
      expect(SignsData.allSigns.length, 20);

      for (final sign in SignsData.allSigns) {
        expect(sign.videoUrl, isNotNull, reason: 'Sign ${sign.id} missing videoUrl');
        expect(sign.videoUrl!.startsWith('https://'), isTrue);
        expect(sign.signbankGlossId, isNotNull, reason: 'Sign ${sign.id} missing signbankGlossId');
        expect(sign.signbankGlossId! > 0, isTrue);
        expect(sign.glossEnglish, isNotNull, reason: 'Sign ${sign.id} missing glossEnglish');
        expect(sign.hasVideo, isTrue);
      }
    });

    testWidgets('SignCard renders video badge when sign has video', (tester) async {
      final signWithVideo = SignsData.allSigns.first;

      await tester.pumpWidget(
        BlocProvider<DictionaryCubit>(
          create: (_) => ServiceLocator.instance.createDictionaryCubit(),
          child: MaterialApp(
            home: Scaffold(
              body: SignCard(sign: signWithVideo),
            ),
          ),
        ),
      );

      expect(find.text('فيديو'), findsOneWidget);
    });

    testWidgets('SignDetailSheet displays mode switcher tabs and video info badge', (tester) async {
      final sign = SignsData.allSigns.first;

      await tester.pumpWidget(
        BlocProvider<DictionaryCubit>(
          create: (_) => ServiceLocator.instance.createDictionaryCubit(),
          child: MaterialApp(
            home: Scaffold(
              body: SignDetailSheet(sign: sign),
            ),
          ),
        ),
      );

      // Verify switcher tabs exist
      expect(find.text('فيديو الإشارة'), findsOneWidget);
      expect(find.text('الحركة التوضيحية'), findsOneWidget);

      // Verify the ASL Signbank verified metadata banner is displayed
      expect(find.text('فيديو معتمد من Yale ASL Signbank'), findsOneWidget);
      expect(find.textContaining('Annotation: ${sign.glossEnglish}'), findsOneWidget);

      // Switch to gesture animation tab
      await tester.tap(find.text('الحركة التوضيحية'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Check gesture animation mode is now displayed with ESL badge
      expect(find.text('لغة الإشارة المصرية ESL'), findsOneWidget);
      expect(find.text(sign.gestureSymbol), findsOneWidget);
    });
  });
}
