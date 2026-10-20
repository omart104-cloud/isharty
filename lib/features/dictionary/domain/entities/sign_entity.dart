import 'package:flutter/foundation.dart';

/// Core domain entity representing a sign language entry in the dictionary.
@immutable
class SignEntity {
  final String id;
  final String arabicWord;
  final String category;
  final String description;
  final String handShape;
  final List<String> movementSteps;
  final String usageNote;
  final String difficulty;
  final bool isPopular;
  final String gestureSymbol;
  final List<String> relatedSignIds;
  final String? videoUrl;
  final int? signbankGlossId;
  final String? glossEnglish;

  const SignEntity({
    required this.id,
    required this.arabicWord,
    required this.category,
    required this.description,
    required this.handShape,
    required this.movementSteps,
    required this.usageNote,
    this.difficulty = 'سهل',
    this.isPopular = false,
    this.gestureSymbol = '✋',
    this.relatedSignIds = const [],
    this.videoUrl,
    this.signbankGlossId,
    this.glossEnglish,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.trim().isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          arabicWord == other.arabicWord &&
          category == other.category &&
          videoUrl == other.videoUrl &&
          signbankGlossId == other.signbankGlossId;

  @override
  int get hashCode =>
      id.hashCode ^
      arabicWord.hashCode ^
      category.hashCode ^
      (videoUrl?.hashCode ?? 0) ^
      (signbankGlossId?.hashCode ?? 0);
}
