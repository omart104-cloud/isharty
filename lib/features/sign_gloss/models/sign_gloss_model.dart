import 'package:flutter/foundation.dart';

/// Data model representing an ASL Signbank dictionary gloss entry.
@immutable
class SignGlossModel {
  /// Unique identifier of the gloss in ASL Signbank.
  final int id;

  /// Primary gloss annotation label (e.g., 'SUMMARIZE', 'DEAF', 'HELLO').
  final String glossName;

  /// Fully-qualified URL pointing to the sign gloss MP4 video file.
  final String? videoUrl;

  /// Returns a verified video URL whose domain matches the server's TLS certificate.
  ///
  /// The Yale Haskins server certificate is issued for CN=aslsignbank.com.
  /// Native players (such as Android ExoPlayer) strictly verify hostnames and reject
  /// aslsignbank.haskins.yale.edu with an SSLPeerUnverifiedException.
  String? get playableVideoUrl {
    if (videoUrl == null) return null;
    return videoUrl!.replaceAll('aslsignbank.haskins.yale.edu', 'aslsignbank.com');
  }

  /// English translation equivalents and keywords associated with this sign.
  final List<String> keywords;

  const SignGlossModel({
    required this.id,
    required this.glossName,
    this.videoUrl,
    this.keywords = const [],
  });

  /// Factory constructor to parse JSON payloads from ASL Signbank API
  /// or intermediate backend caches.
  factory SignGlossModel.fromJson(Map<String, dynamic> json, {int? fallbackId}) {
    final rawId = json['id'] ?? json['pk'] ?? fallbackId ?? 0;
    final int parsedId = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? (fallbackId ?? 0);

    final String name = (json['glossName'] ??
            json['gloss_name'] ??
            json['gloss'] ??
            json['idgloss'] ??
            json['annotation_idgloss'] ??
            json['name'] ??
            'Sign #$parsedId')
        .toString()
        .trim();

    String? video = (json['videoUrl'] ??
            json['video_url'] ??
            json['videourl'] ??
            json['video'])
        ?.toString();

    if (video != null && video.isNotEmpty) {
      if (video.startsWith('//')) {
        video = 'https:$video';
      } else if (video.startsWith('/')) {
        video = 'https://aslsignbank.haskins.yale.edu$video';
      }
    }

    final List<String> parsedKeywords = [];
    final rawKeywords = json['keywords'] ?? json['translation_equivalents'] ?? json['translations'];
    if (rawKeywords is List) {
      for (final item in rawKeywords) {
        if (item != null) {
          final str = item.toString().trim();
          if (str.isNotEmpty) parsedKeywords.add(str);
        }
      }
    } else if (rawKeywords is String && rawKeywords.isNotEmpty) {
      parsedKeywords.addAll(
        rawKeywords.split(RegExp(r'[,;\n]')).map((s) => s.trim()).where((s) => s.isNotEmpty),
      );
    }

    return SignGlossModel(
      id: parsedId,
      glossName: name,
      videoUrl: video,
      keywords: parsedKeywords,
    );
  }

  /// Converts this model instance into a JSON-serializable Map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'glossName': glossName,
        'videoUrl': videoUrl,
        'keywords': keywords,
      };

  /// Returns a copy of this model with updated properties.
  SignGlossModel copyWith({
    int? id,
    String? glossName,
    String? videoUrl,
    List<String>? keywords,
  }) {
    return SignGlossModel(
      id: id ?? this.id,
      glossName: glossName ?? this.glossName,
      videoUrl: videoUrl ?? this.videoUrl,
      keywords: keywords ?? this.keywords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignGlossModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          glossName == other.glossName &&
          videoUrl == other.videoUrl &&
          listEquals(keywords, other.keywords);

  @override
  int get hashCode =>
      id.hashCode ^ glossName.hashCode ^ (videoUrl?.hashCode ?? 0) ^ Object.hashAll(keywords);

  @override
  String toString() =>
      'SignGlossModel(id: $id, glossName: $glossName, videoUrl: $videoUrl, keywords: ${keywords.length})';
}
