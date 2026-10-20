class SituationPhrase {
  final String speaker;
  final String arabicText;
  final String signGuidance;
  final List<String> matchedSignIds;
  final bool isUrgent;

  const SituationPhrase({
    required this.speaker,
    required this.arabicText,
    required this.signGuidance,
    this.matchedSignIds = const [],
    this.isUrgent = false,
  });
}

class SchoolSituationModel {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final int colorValue;
  final List<SituationPhrase> phrases;

  const SchoolSituationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.colorValue,
    required this.phrases,
  });

  int get phrasesCount => phrases.length;
}
