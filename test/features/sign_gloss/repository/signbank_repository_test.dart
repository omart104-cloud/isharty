import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/features/sign_gloss/repository/signbank_repository.dart';

class MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('SignbankRepository', () {
    test('throws SignbankException if id is <= 0', () async {
      final repo = SignbankRepository();
      expect(
        () => repo.fetchGlossById(0),
        throwsA(isA<SignbankException>()),
      );
      expect(
        () => repo.fetchGlossById(-5),
        throwsA(isA<SignbankException>()),
      );
    });

    test('successfully parses HTML response with video and keywords', () async {
      const sampleHtml = '''
<!DOCTYPE html>
<html>
  <head>
    <title>Sign for SUMMARIZE</title>
  </head>
  <body>
    <div id="wrap">
      <div id="definitionblock">
        <table>
          <tr>
            <th>Annotation ID Gloss (English)</th>
            <td id="annotation_idgloss_en_US">SUMMARIZE</td>
          </tr>
          <tr id="keywords">
            <th>Translation equivalents</th>
            <td>abbreviate, abbreviation, concise, condense, summarize</td>
          </tr>
        </table>
        <div id="player">
          <video id="videoplayer" src="/dictionary/protected_media/glossvideo/ASL/SU/SUMMARIZE-1.mp4" controls></video>
        </div>
      </div>
    </div>
  </body>
</html>
''';

      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          sampleHtml,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.textPlainContentType],
          },
        );
      });

      final repo = SignbankRepository(dio: dio);
      final model = await repo.fetchGlossById(1);

      expect(model.id, 1);
      expect(model.glossName, 'SUMMARIZE');
      expect(
        model.videoUrl,
        'https://aslsignbank.haskins.yale.edu/dictionary/protected_media/glossvideo/ASL/SU/SUMMARIZE-1.mp4',
      );
      expect(model.keywords, ['abbreviate', 'abbreviation', 'concise', 'condense', 'summarize']);
    });

    test('extracts video URL from <source src="..."> if <video> has no src', () async {
      const sampleHtml = '''
<!DOCTYPE html>
<html>
  <head>
    <title>Sign for DANCE</title>
  </head>
  <body>
    <div id="wrap">
      <td id="annotation_idgloss_en_US">DANCE</td>
      <video id="videoplayer">
        <source src="/dictionary/protected_media/glossvideo/DANCE.mp4" type="video/mp4" />
      </video>
    </div>
  </body>
</html>
''';

      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          sampleHtml,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.textPlainContentType],
          },
        );
      });

      final repo = SignbankRepository(dio: dio);
      final model = await repo.fetchGlossById(2);

      expect(model.glossName, 'DANCE');
      expect(
        model.videoUrl,
        'https://aslsignbank.haskins.yale.edu/dictionary/protected_media/glossvideo/DANCE.mp4',
      );
    });

    test('throws SignbankNotFoundException when HTML contains missing gloss message', () async {
      const sampleHtml = '''
<!DOCTYPE html>
<html>
  <head>
    <title>ASL Signbank</title>
  </head>
  <body>
    <p>The requested gloss does not exist.</p>
  </body>
</html>
''';

      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          sampleHtml,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.textPlainContentType],
          },
        );
      });

      final repo = SignbankRepository(dio: dio);

      expect(
        () => repo.fetchGlossById(99999),
        throwsA(isA<SignbankNotFoundException>()),
      );
    });

    test('throws SignbankNotFoundException on HTTP 404 status', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          'Not Found',
          404,
          headers: {
            Headers.contentTypeHeader: [Headers.textPlainContentType],
          },
        );
      });

      final repo = SignbankRepository(dio: dio);

      expect(
        () => repo.fetchGlossById(99999),
        throwsA(isA<SignbankNotFoundException>()),
      );
    });

    test('parses JSON string response directly', () async {
      const sampleJson = '''
{
  "id": 10,
  "gloss": "COMPUTER",
  "video_url": "https://media.asl.edu/comp.mp4",
  "keywords": ["pc", "laptop"]
}
''';

      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          sampleJson,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final repo = SignbankRepository(dio: dio);
      final model = await repo.fetchGlossById(10);

      expect(model.id, 10);
      expect(model.glossName, 'COMPUTER');
      expect(model.videoUrl, 'https://media.asl.edu/comp.mp4');
      expect(model.keywords, ['pc', 'laptop']);
    });
  });
}
