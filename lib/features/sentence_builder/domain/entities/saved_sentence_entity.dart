import 'package:flutter/foundation.dart';

@immutable
class SavedSentenceEntity {
  final String id;
  final String sentenceText;
  final List<String> signIds;
  final String formattedDate;

  const SavedSentenceEntity({
    required this.id,
    required this.sentenceText,
    required this.signIds,
    required this.formattedDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedSentenceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sentenceText == other.sentenceText &&
          listEquals(signIds, other.signIds);

  @override
  int get hashCode => id.hashCode ^ sentenceText.hashCode ^ Object.hashAll(signIds);
}
