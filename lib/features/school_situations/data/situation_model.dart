import '../domain/entities/situation_entity.dart';

class SituationPhrase extends SituationPhraseEntity {
  const SituationPhrase({
    required super.speaker,
    required super.arabicText,
    required super.signGuidance,
    super.matchedSignIds = const [],
    super.isUrgent = false,
  });
}

class SchoolSituationModel extends SchoolSituationEntity {
  const SchoolSituationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconEmoji,
    required super.colorValue,
    required super.phrases,
  });
}
