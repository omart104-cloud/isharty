import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/features/sign_gloss/models/sign_gloss_model.dart';

void main() {
  group('SignGlossModel', () {
    test('instantiates with required properties and default keywords', () {
      const model = SignGlossModel(
        id: 1,
        glossName: 'SUMMARIZE',
        videoUrl: 'https://aslsignbank.haskins.yale.edu/media/1.mp4',
      );

      expect(model.id, 1);
      expect(model.glossName, 'SUMMARIZE');
      expect(model.videoUrl, 'https://aslsignbank.haskins.yale.edu/media/1.mp4');
      expect(model.playableVideoUrl, 'https://aslsignbank.com/media/1.mp4');
      expect(model.keywords, isEmpty);
    });

    test('fromJson correctly parses map with relative video URL and keywords list', () {
      final json = {
        'id': 42,
        'gloss': 'DANCE',
        'video_url': '/dictionary/protected_media/glossvideo/dance.mp4',
        'keywords': ['dance', 'dancing', 'ballroom'],
      };

      final model = SignGlossModel.fromJson(json);

      expect(model.id, 42);
      expect(model.glossName, 'DANCE');
      expect(
        model.videoUrl,
        'https://aslsignbank.haskins.yale.edu/dictionary/protected_media/glossvideo/dance.mp4',
      );
      expect(model.keywords, ['dance', 'dancing', 'ballroom']);
    });

    test('fromJson parses comma-separated keywords string and fallback ID', () {
      final json = {
        'gloss': 'HELLO',
        'keywords': 'hi, greetings, welcome',
      };

      final model = SignGlossModel.fromJson(json, fallbackId: 100);

      expect(model.id, 100);
      expect(model.glossName, 'HELLO');
      expect(model.keywords, ['hi', 'greetings', 'welcome']);
    });

    test('toJson and equality work properly', () {
      const model1 = SignGlossModel(
        id: 1,
        glossName: 'SUMMARIZE',
        videoUrl: 'https://example.com/video.mp4',
        keywords: ['summary', 'brief'],
      );

      const model2 = SignGlossModel(
        id: 1,
        glossName: 'SUMMARIZE',
        videoUrl: 'https://example.com/video.mp4',
        keywords: ['summary', 'brief'],
      );

      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));

      final json = model1.toJson();
      expect(json['id'], 1);
      expect(json['glossName'], 'SUMMARIZE');
      expect(json['videoUrl'], 'https://example.com/video.mp4');
      expect(json['keywords'], ['summary', 'brief']);
    });

    test('copyWith updates specified fields', () {
      const original = SignGlossModel(
        id: 1,
        glossName: 'TEST',
      );

      final updated = original.copyWith(
        glossName: 'UPDATED',
        videoUrl: 'https://test.com/vid.mp4',
        keywords: ['new'],
      );

      expect(updated.id, 1);
      expect(updated.glossName, 'UPDATED');
      expect(updated.videoUrl, 'https://test.com/vid.mp4');
      expect(updated.keywords, ['new']);
    });
  });
}
