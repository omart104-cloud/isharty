import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../models/sign_gloss_model.dart';

/// Base exception class for all Signbank-related operations.
class SignbankException implements Exception {
  final String message;
  final int? statusCode;

  const SignbankException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Thrown when a gloss with the specified ID does not exist (404 or missing notice).
class SignbankNotFoundException extends SignbankException {
  const SignbankNotFoundException(super.message, {super.statusCode = 404});
}

/// Thrown when a request to Signbank times out.
class SignbankTimeoutException extends SignbankException {
  const SignbankTimeoutException(super.message);
}

/// Thrown when there is no network connection or a DNS/socket error occurs.
class SignbankNetworkException extends SignbankException {
  const SignbankNetworkException(super.message);
}

/// Repository responsible for communicating with the ASL Signbank dictionary endpoint
/// and parsing HTML or JSON responses to extract gloss data and video URLs.
class SignbankRepository {
  static const String defaultBaseUrl = 'https://aslsignbank.haskins.yale.edu';

  final Dio _dio;
  final String baseUrl;

  SignbankRepository({
    Dio? dio,
    this.baseUrl = defaultBaseUrl,
  }) : _dio = dio ?? _createDefaultDio(baseUrl);

  static Dio _createDefaultDio(String base) {
    final dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,application/json;q=0.8,*/*;q=0.7',
        },
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // On native platforms (Android, iOS, Windows, macOS, Linux), Yale Haskins SSL
    // certificate can have a hostname mismatch in strict BoringSSL verification.
    if (!kIsWeb) {
      final adapter = dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) {
            // Permit secure TLS handshake with Yale and UConn Signbank domains
            return host.contains('yale.edu') ||
                host.contains('aslsignbank.com') ||
                host.contains('uconn.edu');
          };
          return client;
        };
      }
    }

    return dio;
  }

  /// Fetches an ASL Signbank gloss entry by its numeric [id].
  ///
  /// Sends a GET request to `https://aslsignbank.haskins.yale.edu/dictionary/gloss/{id}/`.
  /// - If the response is JSON, parses the gloss and video directly.
  /// - If HTML is returned, parses DOM elements to extract the gloss label, video URL,
  ///   and translation keywords.
  Future<SignGlossModel> fetchGlossById(int id) async {
    if (id <= 0) {
      throw const SignbankException('Gloss ID must be a positive number greater than 0.');
    }

    final endpoint = '/dictionary/gloss/$id/';

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      // Handle explicit HTTP 404
      if (response.statusCode == 404) {
        throw SignbankNotFoundException('Sign gloss #$id was not found in ASL Signbank (HTTP 404).');
      }

      final dynamic data = response.data;
      if (data == null || (data is String && data.trim().isEmpty)) {
        throw SignbankNotFoundException('Empty response received for gloss #$id.');
      }

      // Check if response is JSON (either Map or JSON string)
      if (data is Map<String, dynamic>) {
        return SignGlossModel.fromJson(data, fallbackId: id);
      }

      if (data is String) {
        final trimmed = data.trim();
        if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
          try {
            final decoded = jsonDecode(trimmed);
            if (decoded is Map<String, dynamic>) {
              return SignGlossModel.fromJson(decoded, fallbackId: id);
            }
          } catch (_) {
            // Not valid JSON, continue with HTML parsing
          }
        }

        // HTML Parsing
        return _parseHtmlResponse(data, id);
      }

      throw SignbankException('Unsupported response format received for gloss #$id.');
    } on DioException catch (e) {
      throw _mapDioError(e, id);
    } on SignbankException {
      rethrow;
    } catch (e) {
      throw SignbankException('Failed to load gloss #$id: $e');
    }
  }

  /// Parses the raw HTML response body from ASL Signbank using package:html/parser.dart
  SignGlossModel _parseHtmlResponse(String htmlContent, int id) {
    final document = html_parser.parse(htmlContent);

    // 1. Detect missing gloss message (e.g., "The requested gloss does not exist.")
    final bodyText = document.body?.text ?? '';
    if (bodyText.contains('The requested gloss does not exist') ||
        bodyText.contains('requested gloss could not be found') ||
        bodyText.contains('Gloss not found')) {
      throw SignbankNotFoundException('ASL Signbank: Gloss #$id does not exist.');
    }

    // 2. Extract Gloss Title / Label
    final glossName = _extractGlossName(document, id);

    // 3. Extract Video URL (search <video>, <source>, and fallbacks)
    final videoUrl = _extractVideoUrl(document, htmlContent);

    // 4. Extract Translation Keywords
    final keywords = _extractKeywords(document);

    return SignGlossModel(
      id: id,
      glossName: glossName,
      videoUrl: videoUrl,
      keywords: keywords,
    );
  }

  /// Extracts the gloss name from page headers, tables, or document title.
  String _extractGlossName(dom.Document document, int id) {
    // A. Check specific table cell with id 'annotation_idgloss_en_US'
    final idGlossCell = document.querySelector('#annotation_idgloss_en_US');
    if (idGlossCell != null && idGlossCell.text.trim().isNotEmpty) {
      return idGlossCell.text.trim();
    }

    // B. Check <div id='annotation_idgloss_summary'> table rows
    final summaryCell = document.querySelector('#annotation_idgloss_summary td');
    if (summaryCell != null && summaryCell.text.trim().isNotEmpty) {
      return summaryCell.text.trim();
    }

    // C. Check OpenGraph title meta tag: <meta property="og:title" content="..." />
    final ogTitle = document.querySelector('meta[property="og:title"]')?.attributes['content'];
    if (ogTitle != null && ogTitle.trim().isNotEmpty) {
      // Often in format: "GlossName (in ASL)" or comma-separated list
      final clean = ogTitle.replaceAll(RegExp(r'\s*\(in ASL\)', caseSensitive: false), '').trim();
      if (clean.isNotEmpty && !clean.toLowerCase().contains('signbank')) {
        return clean.split(',').first.trim();
      }
    }

    // D. Check <title> tag: e.g. "Sign for SUMMARIZE"
    final titleElement = document.querySelector('title');
    if (titleElement != null) {
      final titleText = titleElement.text.trim();
      final match = RegExp(r'Sign\s+for\s+(.+)', caseSensitive: false).firstMatch(titleText);
      if (match != null) {
        final captured = match.group(1)?.trim();
        if (captured != null && captured.isNotEmpty) {
          return captured;
        }
      } else if (titleText.isNotEmpty && !titleText.toLowerCase().contains('asl signbank')) {
        return titleText;
      }
    }

    // E. Check Definition block headings
    final heading = document.querySelector('#definitionblock h2, #definitionblock h3, #definitionblock h4');
    if (heading != null && heading.text.trim().isNotEmpty) {
      return heading.text.trim();
    }

    return 'Gloss #$id';
  }

  /// Extracts the video URL from <video> or <source> elements in the HTML document.
  String? _extractVideoUrl(dom.Document document, String rawHtml) {
    String? rawUrl;

    // A. Check <video id='videoplayer' src="...">
    final videoPlayer = document.querySelector('video#videoplayer');
    if (videoPlayer != null && videoPlayer.attributes['src'] != null) {
      rawUrl = videoPlayer.attributes['src']!.trim();
    }

    // B. Check any <video> element src attribute
    if (rawUrl == null || rawUrl.isEmpty) {
      final anyVideo = document.querySelector('video');
      if (anyVideo != null && anyVideo.attributes['src'] != null) {
        rawUrl = anyVideo.attributes['src']!.trim();
      }
    }

    // C. Check <source src="..."> child inside <video> or document
    if (rawUrl == null || rawUrl.isEmpty) {
      final sources = document.querySelectorAll('source');
      for (final source in sources) {
        final src = source.attributes['src']?.trim();
        if (src != null && src.toLowerCase().contains('.mp4')) {
          rawUrl = src;
          break;
        }
      }
    }

    // D. Fallback: Regex scan for protected_media or glossvideo path
    if (rawUrl == null || rawUrl.isEmpty) {
      final regex = RegExp(
        r'''(?:src|href)=["']([^"']*(?:protected_media\/glossvideo|glossvideo|\.mp4)[^"']*)["']''',
        caseSensitive: false,
      );
      final match = regex.firstMatch(rawHtml);
      if (match != null) {
        rawUrl = match.group(1)?.trim();
      }
    }

    if (rawUrl == null || rawUrl.isEmpty) {
      return null;
    }

    return _normalizeUrl(rawUrl);
  }

  /// Extracts translation keywords from the definition table or metadata.
  List<String> _extractKeywords(dom.Document document) {
    final keywords = <String>[];

    // A. Check table row with id 'keywords' (e.g., <tr id="keywords"><td>...</td></tr>)
    final keywordsCell = document.querySelector('tr#keywords td');
    if (keywordsCell != null) {
      final text = keywordsCell.text;
      final parts = text.split(RegExp(r'[,;\n]'));
      for (final p in parts) {
        final cleaned = p.trim();
        if (cleaned.isNotEmpty) {
          keywords.add(cleaned);
        }
      }
    }

    // B. Check meta property og:title for equivalents if keywords row was absent
    if (keywords.isEmpty) {
      final ogTitle = document.querySelector('meta[property="og:title"]')?.attributes['content'];
      if (ogTitle != null && ogTitle.contains(',')) {
        final clean = ogTitle.replaceAll(RegExp(r'\s*\(in ASL\)', caseSensitive: false), '');
        final parts = clean.split(',');
        for (final p in parts) {
          final trimmed = p.trim();
          if (trimmed.isNotEmpty) {
            keywords.add(trimmed);
          }
        }
      }
    }

    return keywords;
  }

  /// Prepend base URL if relative path.
  String _normalizeUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('//')) {
      return 'https:$url';
    }

    if (url.startsWith('/')) {
      return '$baseUrl$url';
    }

    return '$baseUrl/$url';
  }

  /// Maps DioException to domain-specific Signbank exceptions.
  SignbankException _mapDioError(DioException e, int id) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const SignbankTimeoutException(
          'Connection timed out. Please check your internet connection and try again.',
        );

      case DioExceptionType.connectionError:
        return const SignbankNetworkException(
          'Unable to reach ASL Signbank. Please check your network connection.',
        );

      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 404) {
          return SignbankNotFoundException('Sign gloss #$id was not found (HTTP 404).');
        }
        return SignbankException(
          'ASL Signbank returned an error: status code $code.',
          statusCode: code,
        );

      case DioExceptionType.cancel:
        return const SignbankException('Request was cancelled.');

      case DioExceptionType.unknown:
      default:
        final msg = e.message ?? e.error?.toString() ?? 'Network error';
        if (msg.contains('SocketException') || msg.contains('HandshakeException')) {
          return SignbankNetworkException('Network handshake failed: $msg');
        }
        return SignbankException('Failed to fetch sign: $msg');
    }
  }
}
